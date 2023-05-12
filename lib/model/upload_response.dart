import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UploadResponse {
  final bool error;
  final int error_id;
  final String message;


  UploadResponse({
    required this.error,
    required this.error_id,
    required this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      error: json['error'] as bool,
      error_id: json['error_id'] as int,
      message: json['message'] as String
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> tipoDoc = Map<String, dynamic>();
    tipoDoc["error"] = error;
    tipoDoc["error_id"] = error_id;
    tipoDoc["message"] = message;
    return tipoDoc;
  }
}