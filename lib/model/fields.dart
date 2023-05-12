import 'item_combo.dart';

enum camposTipo {
  VARCHAR,
  DATE,
  ANO,
  CPFCNPJ,
  COMBO
}

class Fields {
  final String id_campo;
  final String desccampo;
  final String nomecampo;
  final String tipocampo;
  final String tamcampo;
  final String masccampo;
  final String id_combo;
  final List<ItemCombo> itenscombo;

  Fields(
      {required this.id_campo,
      required this.desccampo,
      required this.nomecampo,
      required this.tipocampo,
      required this.tamcampo,
      required this.masccampo,
      required this.id_combo,
      required this.itenscombo});

  factory Fields.fromJson(Map<String, dynamic> map) {
    var template = map['itenscombo'] as List;
    List<ItemCombo> itensList =
    template.map((i) => ItemCombo.fromMap(i)).toList();

    return Fields(
      id_campo: map['id_campo'],
      desccampo: map['desccampo'],
      nomecampo: map['nomecampo'],
      tipocampo: map['tipocampo'],
      tamcampo: map['tamcampo'],
      masccampo: map['masccampo'],
      id_combo: map['id_combo'],
      itenscombo: itensList,
    );
  }


  Map<String, dynamic> asMap() => {
        'idCampo': id_campo,
        'descCampo': desccampo,
        'nomeCampo': nomecampo,
        'tipoCampo': tipocampo,
        'tamCampo': tamcampo,
        'mascCampo': masccampo,
        'idCombo': id_combo,
        'itensCombo': itenscombo,
      };
}
