import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Login {
  final String idUsuario;
  final String nomeUsuario;
  final String emailUsuario;
  final String authorization_key;
  final bool error;

  Login({
    required this.idUsuario,
    required this.nomeUsuario,
    required this.emailUsuario,
    required this.authorization_key,
    required this.error
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      idUsuario: json['id_usuario'] as String,
      nomeUsuario: json['nome_usuario'] as String,
      emailUsuario: json['email_usuario'] as String,
      authorization_key: json['authorization_key'] as String,
      error: json['error'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = Map<String, dynamic>();
    user["id_usuario"] = idUsuario;
    user["nome_usuario"] = nomeUsuario;
    user["email_usuario"] = emailUsuario;
    user["authorization_key"] = authorization_key;
    user["error"] = error;
    return user;
  }
}