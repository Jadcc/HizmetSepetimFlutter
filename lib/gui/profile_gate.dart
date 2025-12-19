import 'package:flutter/material.dart';
import '../utils/token_store.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profile_screen.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  Future<bool> _isLoggedIn() async {
    final token = await TokenStore.read();
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        // ❌ GİRİŞ YOK
        if (snapshot.data == false) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Hesabın yok veya giriş yapmadın",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Giriş Yap"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text("Kayıt Ol"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ GİRİŞ VAR
        return const ProfileScreen();
      },
    );
  }
}
