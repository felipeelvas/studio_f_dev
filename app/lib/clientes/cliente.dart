class Cliente {
  final int? id;
  final String nome;
  final String telefone;

  const Cliente({this.id, required this.nome, required this.telefone});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
    );
  }
}
