class Template {
  final String id_tipo;
  final String nome_tipo;
  final String nome_divisao;

  Template( {
    required this.id_tipo,
    required this.nome_tipo,
    required this.nome_divisao
  });

  Template.fromMap(Map map)
      : this(
    id_tipo : map['id_tipo'],
    nome_tipo : map['nome_tipo'],
    nome_divisao : map['nome_divisao'],
  );

  Map<String, dynamic> asMap() => {
    'idTipo' : id_tipo,
    'nomeTipo' : nome_tipo,
    'nomeDivisao' : nome_divisao,
  };

}