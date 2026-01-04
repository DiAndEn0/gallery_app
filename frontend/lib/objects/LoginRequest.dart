class LoginRequest {
  final String email;
  final String password;
  final String role;
  final String? token;

  LoginRequest({required this.email, required this.password, required this.role, required this.token});

  Map<String, dynamic> toJson() => {
    'email' : email,
    'password' : password,
    'role' : role,
    'token' : token,
  };
}