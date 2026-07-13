import 'package:flutter/material.dart';

class ResourceScreen extends StatelessWidget {
  const ResourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: const Center(
        child: Text('Listagem de Salas e Equipamentos (Em breve)'),
      ),
    );
  }
}
