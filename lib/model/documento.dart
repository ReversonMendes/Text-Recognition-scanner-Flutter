import 'campos.dart';

enum DocTipo { BOLETO, NF, CNH, IR }

class Documento {
  final DocTipo tipo;
  final String title, image;
  final bool active;
  final List<Campos> campos;

  const Documento(
      {required this.tipo,
      required this.title,
      required this.image,
      required this.active,
      required this.campos});

  Documento.fromMap(Map map)
      : this(
          tipo: map['tipo'],
          title: map['title'],
          image: map['image'],
          active: map['active'],
          campos: map['campos'],
        );

  Map<String, dynamic> asMap() => {
        'tipo': tipo,
        'title': title,
        "image": image,
        "active": active,
        "campos": campos,
      };
}
