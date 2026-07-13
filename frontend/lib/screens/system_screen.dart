import 'package:flutter/material.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema e Notificações'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: const Center(
        child: Text('Alertas e Logs do Sistema (Em breve)'),
      ),
    );
  }
}
