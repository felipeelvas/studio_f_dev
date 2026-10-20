import 'package:flutter/material.dart';

import 'cliente.dart';
import 'cliente_form_page.dart';
import 'cliente_service.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _service = ClienteService();
  final List<Cliente> _clientes = [];

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    try {
      final clientes = await _service.listarClientes();

      if (!mounted) return;

      setState(() {
        _clientes.clear();
        _clientes.addAll(clientes);
        _carregando = false;
        _erro = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro =
            'Não foi possível carregar os clientes. '
            'Confira se o servidor está funcionando.';
      });
    }
  }

  Future<void> _abrirCadastro() async {
    final cliente = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute<Cliente>(builder: (context) => const ClienteFormPage()),
    );

    if (!mounted || cliente == null) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final clienteSalvo = await _service.cadastrarCliente(cliente);

      if (!mounted) return;

      setState(() {
        _clientes.add(clienteSalvo);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente cadastrado no servidor!')),
      );
    } catch (erro) {
      if (!mounted) return;

      final mensagem = erro is Exception
          ? erro.toString().replaceFirst('Exception: ', '')
          : 'Não foi possível cadastrar o cliente.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final alterado = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute<Cliente>(
        builder: (context) => ClienteFormPage(cliente: cliente),
      ),
    );

    if (!mounted || alterado == null) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final salvo = await _service.atualizarCliente(alterado);

      if (!mounted) return;

      setState(() {
        final indice = _clientes.indexWhere((item) => item.id == salvo.id);

        if (indice != -1) {
          _clientes[indice] = salvo;
        }
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cliente atualizado!')));
    } catch (erro) {
      if (!mounted) return;

      final mensagem = erro is Exception
          ? erro.toString().replaceFirst('Exception: ', '')
          : 'Não foi possível atualizar o cliente.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Future<void> _excluirCliente(Cliente cliente) async {
    final id = cliente.id;

    if (_carregando || id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir cliente?'),
        content: Text(
          'Deseja excluir ${cliente.nome}? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true || _carregando) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await _service.excluirCliente(id);

      if (!mounted) return;

      setState(() {
        _clientes.removeWhere((item) => item.id == id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cliente excluído.')));
    } catch (erro) {
      if (!mounted) return;

      final mensagem = erro is Exception
          ? erro.toString().replaceFirst('Exception: ', '')
          : 'Não foi possível excluir o cliente.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        tooltip: 'Novo cliente',
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_erro!),
              ),
            )
          : ListView.builder(
              itemCount: _clientes.length,
              itemBuilder: (context, index) {
                final cliente = _clientes[index];

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(cliente.nome),
                  subtitle: Text(cliente.telefone),
                  onTap: _carregando ? null : () => _editarCliente(cliente),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Editar cliente',
                        icon: const Icon(Icons.edit),
                        onPressed: _carregando
                            ? null
                            : () => _editarCliente(cliente),
                      ),
                      IconButton(
                        tooltip: 'Excluir cliente',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: _carregando
                            ? null
                            : () => _excluirCliente(cliente),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
