import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../model/upload_response.dart';

class UploadService {
  final String postsURL =
      "http://app.gedbyebyepaper.com.br:9090/idocs_bbpaper/api/v1/documents/uploadbase64";

  Future<UploadResponse?> uploadArchive(String idTipo, String path, List<String> params) async {
    final login = await SessionManager().get('user');
    String token = login['authorization_key'];

    File imagefile = File(path); //convert Path to File
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes); //convert bytes to base64 string

    // List<MultipartFile> files = [];
    // for (var path in paths) files.add(await MultipartFile.fromFile(path));

    var formData = FormData.fromMap({});
    formData.fields.add(MapEntry('id_tipo', idTipo));
    formData.fields.add(MapEntry('formato', 'pdf'));
    for (var i = 0; i < params.length; i++) {
      formData.fields.add(MapEntry('cp[]', params[i]));
    }

    DateTime today = DateTime.now();
    String namefile = "${today.day}-${today.month}-${today.year}-${today.hour}-${today.minute}-${today.second}.pdf";
    //String namefile = "${DateTime.now().millisecondsSinceEpoch}.pdf";

    formData.fields.add(MapEntry('documento_nome', namefile));
    formData.fields.add(MapEntry('documento', base64string));
    // formData.files.add(MapEntry('documento', await MultipartFile.fromFile(path)));

    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "${token}";

    var response = await dio.post(postsURL, data: formData);

    if (response.statusCode == 200) {
      UploadResponse uploadResponse = UploadResponse.fromJson(response.data);
      return uploadResponse;
    }
    return null;
  }
}
