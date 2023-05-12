import 'package:capture_prime/features/widgets/account_field.dart';
import 'package:capture_prime/features/widgets/email_field.dart';
import 'package:capture_prime/features/widgets/get_started_button.dart';
import 'package:capture_prime/features/widgets/password_field.dart';
import 'package:capture_prime/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../model/login.dart';
import '../../styles/colors.dart';
import '../scanner_doc/scanner_doc_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController accountController;
  final LoginService loginService = LoginService();

  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    accountController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          bottom: false,
          child: FutureBuilder(
            future: SessionManager().get('user'),
            builder: (context, snapshot) => snapshot.hasData
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                    child: ScanScreen())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 70),
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            tween: Tween(begin: 1, end: _elementsOpacity),
                            builder: (_, value, __) => Opacity(
                              opacity: value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.cloud_done,
                                      size: 60, color: blueColor),
                                  const SizedBox(height: 25),
                                  const Text(
                                    "Capture Prime,",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 35),
                                  ),
                                  Text(
                                    "O lado oculto da produtividade.",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                AccountField(
                                    fadeAccount: _elementsOpacity == 0,
                                    accountController: accountController),
                                const SizedBox(height: 40),
                                EmailField(
                                    fadeEmail: _elementsOpacity == 0,
                                    emailController: emailController),
                                const SizedBox(height: 40),
                                PasswordField(
                                    fadePassword: _elementsOpacity == 0,
                                    passwordController: passwordController),
                                const SizedBox(height: 60),
                                GetStartedButton(
                                  elementsOpacity: _elementsOpacity,
                                  onTap: () {
                                    setState(() {
                                      _login(
                                          emailController.text,
                                          passwordController.text,
                                          accountController.text);
                                    });
                                  },
                                  onAnimatinoEnd: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    setState(() {
                                      loadingBallAppear = true;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          )),
    );
  }

  Future<void> _login(String usuario, String senha, String conta) async {
    if (await SessionManager().containsKey('user')) {
      _elementsOpacity = 0;
    } else {
      Login? login = await loginService.getLogin(usuario, senha, conta);
      if (login != null) {
        await SessionManager().set('user', login);
        _elementsOpacity = 0;
      } else {
        _showToast(context);
      }
    }
    setState(() {});
  }

  void _showToast(BuildContext context) {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
    EasyLoading.showInfo('Ops, não foi possível fazer o login!', duration: const Duration(seconds: 3), dismissOnTap: true);
  }

}
