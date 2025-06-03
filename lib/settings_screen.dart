import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConfig extends StatefulWidget {
  const TelaConfig({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaConfigState createState() => _TelaConfigState();
}

class _TelaConfigState extends State<TelaConfig> {
  String _orderBy = 'relevance'; // padrão

  @override
  void initState() {
    super.initState();
    _carregarConfiguracao();
  }

  Future<void> _carregarConfiguracao() async {
    final prefs = await SharedPreferences.getInstance();
    final order = prefs.getString('orderBy') ?? 'relevance';
    setState(() {
      _orderBy = order;
    });
  }

  Future<void> _salvarConfiguracao(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderBy', value);
    setState(() {
      _orderBy = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: const Text('Ordenar por relevância'),
            leading: Radio<String>(
              value: 'relevance',
              groupValue: _orderBy,
              onChanged: (value) {
                if (value != null) _salvarConfiguracao(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Ordenar pelos mais recentes'),
            leading: Radio<String>(
              value: 'newest',
              groupValue: _orderBy,
              onChanged: (value) {
                if (value != null) _salvarConfiguracao(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}