import 'dart:core';

import 'package:flutter/material.dart';

class User  {
  final String? email;
  final String? name;
  final String? role;
  final String? token;

  const User({required this.email,  this.name, required this.role, this.token});

  User.fromJson(Map<String, dynamic> json):
      email = json['email'],
      name = json['name'],
      role = json['role'],
      token = json['token'];



  static Map<String,dynamic> toJsonSignup(User user) =>
      {'email' : user.email,  'name' : user.name, 'role' : user.role, 'token' : user.token};

  static Map<String,dynamic> toJsonLogin(User user) =>
      {'email' : user.email,'role' : user.role, 'token' : user.token};
}
