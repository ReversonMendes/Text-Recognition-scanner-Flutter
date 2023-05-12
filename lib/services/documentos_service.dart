import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../model/template_fields.dart';
import '../model/tipos_documentos_user.dart';

class TemplatesService {
  final String getsURL =
      "http://app.gedbyebyepaper.com.br:9090/idocs_bbpaper/api/v1/templates/getall";
  final String postURL =
      "http://app.gedbyebyepaper.com.br:9090/idocs_bbpaper/api/v1/templates/getfields";

  Future<TipoDocumentoUser?> getAll() async {
    final login = await SessionManager().get('user');
    String token = login['authorization_key'];

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(getsURL));
    request.headers.set('Authorization', token, preserveHeaderCase: true);

    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic> data = jsonDecode(reply);
      TipoDocumentoUser docUser = TipoDocumentoUser.fromJson(data);
      print(data);
      return docUser;
    }

    httpClient.close();
    return null;
  }

  Future<TemplateFields?> getFields(String idTemplate) async {
    final login = await SessionManager().get('user');
    String token = login['authorization_key'];

    var formData = FormData.fromMap({'id_template': idTemplate});

    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = token;

    var response = await dio.post(postURL, data: formData);

    if (response.statusCode == 200) {
      TemplateFields templateFields = TemplateFields.fromJson(response.data);
      return templateFields;
    }

    return null;
  }
}
