
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gallery_app/objects/LoginRequest.dart';
import 'package:gallery_app/objects/RegisterRequest.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../AppConfig.dart';
import '../Objects/User.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  User? _currentUser;

  User? getCurrentUser() => _currentUser;

  Future<void> handleLoginSuccess(Map<String, dynamic> responseData) async {
    _currentUser = User.fromJson(responseData);

    if (_currentUser?.token != null) {
      await _storage.write(key: 'auth_token', value: _currentUser!.token);
      await _storage.write(key: 'email', value: _currentUser!.email);
      await _storage.write(key: 'name', value: _currentUser!.name);
      await _storage.write(key: 'role', value: _currentUser!.role);
    }
  }

  Future<void> tryAutoLogin() async {
    if (await _storage.containsKey(key: 'auth_token')) {
      final token = await _storage.read(key: 'auth_token');
      if (JwtDecoder.isExpired(token!)) {
        await logout();
        return;
      }
      final email = await _storage.read(key: 'email');
      final name = await _storage.read(key: 'name');
      final role = await _storage.read(key: 'role');

      _currentUser = User(email: email, name: name, token: token, role: role);
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _storage.deleteAll();
  }

  Future<http.Response> createHttpSignupRequest(RegisterRequest request){
    String encodedJson = jsonEncode(
        request,
        toEncodable: (Object? request) => request is RegisterRequest
            ? request.toJson() : throw UnsupportedError('Cannot convert to JSON: $request'));
    return http.post(
        Uri.parse('${AppConfig.getBaseUrl()}/auth/register'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: encodedJson
    );
  }

  Future<http.Response> createHttpLoginRequest(LoginRequest request) {
    String encodedJson = jsonEncode(
        request,
        toEncodable: (Object? request) => request is LoginRequest
            ? request.toJson() : throw UnsupportedError('Cannot convert to JSON: $request'));
    return http.post(
        Uri.parse('${AppConfig.getBaseUrl()}/auth/login'),
        headers: <String, String> {
          'Content-Type' : 'application/json; charset=UTF-8'
        },
        body: encodedJson
    );
  }

}