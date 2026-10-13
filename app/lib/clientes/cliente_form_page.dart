import 'package:flutter/material.dart';

import 'cliente.dart';

class ClienteFormPage extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  late final TextEditingController _nomeController;
  late final TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');

    _telefoneController = TextEditingController(
      text: widget.cliente?.telefone ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _salvar() {
    final nome = _nomeController.text.trim();
    final telefone = _telefoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (nome.isEmpty || telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome e telefone.')),
      );
      return;
    }

    final cliente = Cliente(
      id: widget.cliente?.id,
      nome: nome,
      telefone: telefone,
    );

    Navigator.pop(context, cliente);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar cliente' : 'Novo cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
