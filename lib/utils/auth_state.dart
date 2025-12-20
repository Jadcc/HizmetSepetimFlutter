import 'package:flutter/material.dart';

class UserSession {
  final String name;
  final String email;
  final String role;
  final String phone;

  UserSession({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
      };

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      name: json["name"] ?? "Kullanıcı",
      email: json["email"] ?? "",
      role: json["role"] ?? "ALICI",
      phone: json["phone"] ?? "",
    );
  }
}


final authState = ValueNotifier<bool>(false);
final userSession = ValueNotifier<UserSession?>(null);
