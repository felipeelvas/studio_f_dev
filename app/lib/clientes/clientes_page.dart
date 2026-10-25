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
  String _busca = '';

  List<Cliente> get _clientesFiltrados {
    final termo = _busca.trim().toLowerCase();
    final telefoneBuscado = termo.replaceAll(RegExp(r'[^0-9]'), '');

    if (termo.isEmpty) {
      return _clientes;
    }

    return _clientes.where((cliente) {
      final nomeEncontrado = cliente.nome.toLowerCase().contains(termo);

      final telefoneEncontrado =
          telefoneBuscado.isNotEmpty &&
          cliente.telefone.contains(telefoneBuscado);

      return nomeEncontrado || telefoneEncontrado;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final clientes = await _service.listarClientes();

      if (!mounted) return;

      setState(() {
        _clientes.clear();
        _clientes.addAll(clientes);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _erro =
            'Não foi possível carregar os clientes. '
            'Confira se o servidor está funcionando.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Future<void> _abrirCadastro() async {
    final salvo = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute<Cliente>(builder: (context) => const ClienteFormPage()),
    );

    if (!mounted || salvo == null) return;

    setState(() {
      _clientes.add(salvo);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cliente cadastrado!')));
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final salvo = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute<Cliente>(
        builder: (context) => ClienteFormPage(cliente: cliente),
      ),
    );

    if (!mounted || salvo == null) return;

    setState(() {
      final indice = _clientes.indexWhere((item) => item.id == salvo.id);

      if (indice != -1) {
        _clientes[indice] = salvo;
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cliente atualizado!')));
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
    final clientesExibidos = _clientesFiltrados;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            tooltip: 'Atualizar clientes',
            onPressed: _carregando ? null : _carregarClientes,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        tooltip: 'Novo cliente',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nome ou telefone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  _busca = valor;
                });
              },
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _erro != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(_erro!),
                    ),
                  )
                : clientesExibidos.isEmpty
                ? Center(
                    child: Text(
                      _clientes.isEmpty
                          ? 'Nenhum cliente cadastrado.'
                          : 'Nenhum cliente encontrado.',
                    ),
                  )
                : ListView.builder(
                    itemCount: clientesExibidos.length,
                    itemBuilder: (context, index) {
                      final cliente = clientesExibidos[index];

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(cliente.nome),
                        subtitle: Text(cliente.telefone),
                        onTap: () => _editarCliente(cliente),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar cliente',
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editarCliente(cliente),
                            ),
                            IconButton(
                              tooltip: 'Excluir cliente',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _excluirCliente(cliente),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
