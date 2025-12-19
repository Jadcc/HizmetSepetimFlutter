import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../utils/token_store.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final api = ApiService();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);

    final res = await api.register(
      firstName: nameCtrl.text,
      lastName: "-",
      email: emailCtrl.text,
      phone: phoneCtrl.text,
      password: passCtrl.text,
    );

    if (!mounted) return;

    if (res != null && res.token.isNotEmpty) {
      await TokenStore.save(res.token);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarısız")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Ad Soyad")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "E-posta")),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Telefon")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Şifre")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : _register,
              child: loading ? const CircularProgressIndicator() : const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
