import 'package:flutter/material.dart';
import 'clientes/clientes_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Studio F Beauty')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClientesPage()),
            );
          },
          child: const Text('Clientes'),
        ),
      ),
    );
  }
}
