import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

const users =  {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}, Username: ${data.additionalSignupData?.entries.first.value}');

    return Future.delayed(loginTime).then((_) {

    });
  }

  // Future<http.Response> createHttpSignupResponse(){
  //    return http.post()
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      leading: BackButton(),
    ),
        extendBodyBehindAppBar: true,
        body: FlutterLogin(
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      }, onRecoverPassword: (String p1) {
        return null;
      },
      hideProvidersTitle: true,
      hideForgotPasswordButton: true,
          additionalSignupFields: [
            UserFormField(
              keyName: AutofillHints.username,
              displayName: "Username",
            ),
          ],
        )
    );
  }
}