import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'features/login/login_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),
        textTheme: const TextTheme(
          subtitle1: TextStyle(color: Colors.black), //<-- SEE HERE
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
      home: const LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}
