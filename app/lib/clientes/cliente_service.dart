import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'cliente.dart';

class ClienteService {
  Future<List<Cliente>> listarClientes() async {
    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';

    final url = Uri.parse('http://$host:8080/clientes');

    final resposta = await http.get(url).timeout(const Duration(seconds: 10));

    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível carregar os clientes.');
    }

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;

    return dados.map((item) {
      return Cliente.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<Cliente> cadastrarCliente(Cliente cliente) async {
    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';

    final url = Uri.parse('http://$host:8080/clientes');

    final resposta = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({
            'nome': cliente.nome,
            'telefone': cliente.telefone,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (resposta.statusCode == 409) {
      throw Exception('Já existe um cliente com esse telefone.');
    }

    if (resposta.statusCode == 400) {
      throw Exception('Confira o nome e o telefone informados.');
    }

    if (resposta.statusCode != 201) {
      throw Exception('Não foi possível cadastrar o cliente.');
    }

    final dados =
        jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;

    return Cliente.fromJson(dados);
  }

  Future<Cliente> atualizarCliente(Cliente cliente) async {
    final id = cliente.id;

    if (id == null) {
      throw Exception('O cliente precisa ter um id para ser editado.');
    }

    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';

    final url = Uri.parse('http://$host:8080/clientes/$id');

    final resposta = await http
        .put(
          url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({
            'nome': cliente.nome,
            'telefone': cliente.telefone,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (resposta.statusCode == 400) {
      throw Exception('Confira o nome e o telefone informados.');
    }

    if (resposta.statusCode == 404) {
      throw Exception('Cliente não encontrado.');
    }

    if (resposta.statusCode == 409) {
      throw Exception('Já existe um cliente com esse telefone.');
    }

    if (resposta.statusCode != 200) {
      throw Exception('Não foi possível atualizar o cliente.');
    }

    final dados =
        jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;

    return Cliente.fromJson(dados);
  }
}
