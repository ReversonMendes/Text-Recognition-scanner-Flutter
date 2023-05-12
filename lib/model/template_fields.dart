import 'package:capture_prime/model/template.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fields.dart';

@JsonSerializable()
class TemplateFields {
  final bool error;
  final int error_id;
  final String message;
  final List<Fields> fields;

  TemplateFields({
    required this.error,
    required this.error_id,
    required this.message,
    required this.fields,
  });

  factory TemplateFields.fromJson(Map<String, dynamic> json) {
    var template = json['fields'] as List;
    List<Fields> templatesList =
        template.map((i) => Fields.fromJson(i)).toList();

    return TemplateFields(
      error: json['error'] as bool,
      error_id: json['error_id'] as int,
      message: json['message'] as String,
      fields: templatesList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> tipoDoc = Map<String, dynamic>();
    tipoDoc["error"] = error;
    tipoDoc["error_id"] = error_id;
    tipoDoc["message"] = message;
    tipoDoc["fields"] = fields;
    return tipoDoc;
  }
}
