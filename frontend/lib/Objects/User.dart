import 'dart:core';

import 'package:flutter/material.dart';

class User  {
  final String? email;
  final String? password;
  final String? name;
  final String role;

  const User({required this.email, required this.password, required this.name, required this.role});

  User.fromJson(Map<String, dynamic> json):
      email = json['email'],
      password = json['password'],
      name = json['name'],
      role = json['role'];

  static Map<String,dynamic> toJson(User user) =>
      {'email' : user.email, 'password' : user.password, 'name' : user.name, 'role' : user.role};
}
