import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_busca_livros/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaBuscaState createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  final TextEditingController controllerLivros = TextEditingController();
  List<dynamic> _livros = [];
  bool _carregando = false;


  Future<void> _buscarLivros() async {
    final termo = controllerLivros.text.trim();
    if (termo.isEmpty) return;

    setState(() {
      _carregando = true;
      _livros.clear();
    });

    final prefs = await SharedPreferences.getInstance();
    final orderBy = prefs.getString('orderBy') ?? 'relevance';

   final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$termo&orderBy=$orderBy');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _livros = data['items'] ?? [];
        _carregando = false;
      });
    } else {
      setState(() {
        _carregando = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao buscar dados')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controllerLivros,
              decoration: InputDecoration(
                labelText: 'Digite titulo, autor ou palavra-chave',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            
            ElevatedButton(onPressed: _buscarLivros, child: Text('Buscar')),
            SizedBox(height: 16),
            _carregando
                ? CircularProgressIndicator()
                : Expanded(
                  child: ListView.builder(
                    itemCount: _livros.length,
                    itemBuilder: (context, index) {
                      final livro = _livros[index];
                      final volumeInfo = livro['volumeInfo'] ?? {};
                      final title = volumeInfo['title'] ?? 'Sem título';
                      final authors =
                          volumeInfo['authors'] != null
                              ? (volumeInfo['authors'] as List).join(', ')
                              : 'Autor desconhecido';

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(authors),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaDetails(livro: livro),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
