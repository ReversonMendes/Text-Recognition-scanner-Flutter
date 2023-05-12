class ItemCombo {
  final String id_item;
  final String descitem;
  final String valoritem;

  ItemCombo( {
    required this.id_item,
    required this.descitem,
    required this.valoritem
  });

  ItemCombo.fromMap(Map map)
      : this(
    id_item : map['id_item'],
    descitem : map['descitem'],
    valoritem : map['valoritem'],
  );

  Map<String, dynamic> asMap() => {
    'idItem' : id_item,
    'descItem' : descitem,
    'valorItem' : valoritem,
  };

}