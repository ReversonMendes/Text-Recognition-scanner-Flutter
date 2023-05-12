enum camposTipo {
  TEXTO,
  DATA,
  ANO,
  CPFCNPJ,
  COMBO
}

class Campos {
  final camposTipo tipo;
  final String title;


  Campos({
    required this.tipo,
    required this.title,
  });

  Campos.fromMap(Map map)
      : this(
    tipo : map['tipo'],
    title : map['title'],
  );

  Map<String, dynamic> asMap() => {
    'tipo' : tipo,
    'title' : title,
  };
}