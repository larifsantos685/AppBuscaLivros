import 'package:app_busca_livros/book_search_screen.dart';
import 'package:app_busca_livros/history_screen.dart';
import 'package:app_busca_livros/settings_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca de Livros',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
   
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _telas = const [
    TelaBusca(),
    TelaHistorico(),
    TelaConfig(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Busca de Livros')),
      body: _telas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Historico'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Configuração'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}