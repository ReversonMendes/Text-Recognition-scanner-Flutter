import 'package:capture_prime/model/template.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TipoDocumentoUser {
  final bool error;
  final int error_id;
  final String message;
  final List<Template> templates;

  // "error": false,
  // "error_id": 0,
  // "message": "Templates listed succesfully",
  // "templates": [
  // {
  // "id_tipo": "96",
  // "nome_tipo": "Mov Financeiro",
  // "nome_divisao": "CDL"
  // },
  // {
  // "id_tipo": "110",
  // "nome_tipo": "Boletos",
  // "nome_divisao": "Contabilidade"
  // },]

  TipoDocumentoUser( {
    required this.error,
    required this.error_id,
    required this.message,
    required this.templates,
  });

  factory TipoDocumentoUser.fromJson(Map<String, dynamic> json) {

    var template = json['templates'] as List;
    List<Template> templatesList = template.map((i) => Template.fromMap(i)).toList();

    return TipoDocumentoUser(
      error: json['error'] as bool,
      error_id: json['error_id'] as int,
      message: json['message'] as String,
      templates: templatesList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> tipoDoc = Map<String, dynamic>();
    tipoDoc["error"] = error;
    tipoDoc["error_id"] = error_id;
    tipoDoc["message"] = message;
    tipoDoc["templates"] = templates;
    return tipoDoc;
  }
// /// Connect the generated [_$PersonFromJson] function to the `fromJson`
// /// factory.
// factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
//
// /// Connect the generated [_$PersonToJson] function to the `toJson` method.
// Map<String, dynamic> toJson() => _$LoginToJson(this);
}

