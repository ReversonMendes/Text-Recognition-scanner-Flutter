import 'package:capture_prime/model/template.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TipoDocumentoUser {
  final bool error;
  final int error_id;
  final String message;
  final List<Template> templates;

  TipoDocumentoUser({
    required this.error,
    required this.error_id,
    required this.message,
    required this.templates,
  });

  factory TipoDocumentoUser.fromJson(Map<String, dynamic> json) {
    var template = json['templates'] as List;
    List<Template> templatesList =
        template.map((i) => Template.fromMap(i)).toList();

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
}
