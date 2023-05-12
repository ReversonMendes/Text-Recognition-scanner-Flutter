import '../model/login.dart';
import 'package:dio/dio.dart';

class LoginService {
  final String postsURL =
      "http://app.gedbyebyepaper.com.br:9090/idocs_bbpaper/api/v1/login";

  Future<Login?> getLogin(String usuario, String senha, String conta) async {
    var formData = FormData.fromMap({
      'conta': conta,
      'usuario': usuario,
      'senha': senha,
      'id_interface': '0'
    });

    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    var res = await dio.post(postsURL, data: formData);
    if (res.statusCode == 200) {
      if (res.data['error'] == false) {
        Login login = Login.fromJson(res.data);
        return login;
      } else {
        return null;
      }
    } else {
      print(res.statusCode);
      throw "Unable to retrieve posts.";
    }
  }
}
