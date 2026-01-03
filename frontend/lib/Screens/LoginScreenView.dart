import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import '../AppConfig.dart';
import '../Objects/User.dart';
import 'HomePageView.dart';

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
    http.Response response = await createHttpSignupRequest(User(email: data.name,
        password: data.password,
        name: data.additionalSignupData?.entries.first.value,
        role: 'USER'
    )
    );
      return response.body.toString();
  }


  Future<http.Response> createHttpSignupRequest(User user){
    String encodedJson = jsonEncode(
        user,
        toEncodable: (Object? user) => user is User
            ? User.toJson(user) : throw UnsupportedError('Cannot convert to JSON: $user'));
    return http.post(
       Uri.parse('http://${AppConfig.getBaseUrl()}/auth/register'),
       headers: <String, String> {
         'Content-Type': 'application/json; charset=UTF-8'
       },
       body: encodedJson
       );
  }


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
              keyName: 'full_name',
              displayName: "name",
            ),
          ],
        )
    );
  }
}