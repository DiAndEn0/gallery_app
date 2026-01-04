class LoginRequest {
  final String email;
  final String password;
  final String role;

  LoginRequest({required this.email, required this.password, required this.role});

  Map<String, dynamic> toJson() => {
    'email' : email,
    'password' : password,
    'role' : role,
  };

}