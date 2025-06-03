import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class TelaDetails extends StatefulWidget {
  final Map<String, dynamic> livro;

  const TelaDetails({super.key, required this.livro});

  @override
  // ignore: library_private_types_in_public_api
  _TelaDetailsState createState() => _TelaDetailsState();
}

class _TelaDetailsState extends State<TelaDetails> {

  @override
void initState() {
  super.initState();
  _salvarNoHistorico();
}

Future<void> _salvarNoHistorico() async {
  final prefs = await SharedPreferences.getInstance();
  final listaString = prefs.getStringList('historicoLivros') ?? [];

  // Verifica se o livro já está no histórico (evita duplicata)
  final livroJson = json.encode(widget.livro['volumeInfo']);
  if (!listaString.contains(livroJson)) {
    listaString.add(livroJson);
    await prefs.setStringList('historicoLivros', listaString);
   }
}
  @override
  Widget build(BuildContext context) {
    final volumeInfo = widget.livro['volumeInfo'] ?? {};
    
    final title = volumeInfo['title'] ?? 'Sem Título';
    final subtitle = volumeInfo['subtitle'] ?? '';
    final authors = volumeInfo['authors'] != null
        ? (volumeInfo['authors'] as List).join(', ')
        : 'Autor desconhecido';
    final pageCount = volumeInfo['pageCount']?.toString() ?? 'Desconhecido';
    final categories = volumeInfo['categories'] != null
        ? (volumeInfo['categories'] as List).join(', ')
        : 'Sem categoria';
    final imageUrl = (volumeInfo['imageLinks']?['thumbnail'] as String?)?.replaceFirst('http', 'https');
    
    final previewLink = volumeInfo['previewLink'];
    
    // final description = volumeInfo['description'] ?? 'Sem descrição';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Center(
                child: Image.network(
                  imageUrl,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Imagem indisponível');
                  },
                ),
            )else
              const Center(
                child: Text('Sem imagem'),
              ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            if (subtitle.isNotEmpty)
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            Text('Autor(es): $authors'),
            Text('Páginas: $pageCount'),
            Text('Categorias: $categories'),
            const SizedBox(height: 12),
            const Text('Descrição:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 8),
            // Text(description),
            const SizedBox(height: 20),
            if (previewLink != null)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(previewLink))) {
                      launchUrl(Uri.parse(previewLink),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text('Visualizar Livro Online'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}







