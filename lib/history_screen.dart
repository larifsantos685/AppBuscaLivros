import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaHistoricoState createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  List<Map<String, dynamic>> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final listaString = prefs.getStringList('historicoLivros') ?? [];
    setState(() {
      _historico = listaString.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _historico.isEmpty
          ? Center(child: Text('Nenhum livro visualizado ainda.'))
          : ListView.builder(
              itemCount: _historico.length,
              itemBuilder: (context, index) {
                final livro = _historico[index];
                final title = livro['title'] ?? 'Sem título';
                final authors = livro['authors'] != null
                    ? (livro['authors'] as List).join(', ')
                    : 'Autor desconhecido';

                return ListTile(
                  title: Text(title),
                  subtitle: Text(authors),
                );
              },
            ),
    );
  }
}