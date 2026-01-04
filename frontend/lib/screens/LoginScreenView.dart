import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:gallery_app/objects/LoginRequest.dart';
import 'package:gallery_app/objects/RegisterRequest.dart';
import 'package:http/http.dart' as http;
import '../Objects/User.dart';
import '../Services/AuthService.dart';
import 'HomePageView.dart';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  Future<String?> _authUser(LoginData data) async {
    //debugPrint('Name: ${data.name}, Password: ${data.password}');
    try {
      LoginRequest request = LoginRequest(email: data.name, password: data.password, role: 'USER');
      http.Response response = await AuthService().createHttpLoginRequest(request);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print("im here");
      if (response.statusCode != 200)
        {
          throw Exception('${response.statusCode} : ${responseData.remove('error_message')}');
        }
      AuthService().handleLoginSuccess(responseData);
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    //debugPrint('Signup Name: ${data.name}, Password: ${data.password}, Username: ${data.additionalSignupData?.entries.first.value}');
    try {
      RegisterRequest request = RegisterRequest(email: data.name,
          password: data.password,
          name: data.additionalSignupData?.entries.first.value,
          role: 'USER');
      http.Response response = await AuthService().createHttpSignupRequest(request);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode != 200)
      {
        throw Exception('${response.statusCode} : ${responseData.remove('error_message')}');
      }
      AuthService().handleLoginSuccess(responseData);
    } on Exception catch (e) {
      return e.toString();
    }
      return null;
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
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePageView(),
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