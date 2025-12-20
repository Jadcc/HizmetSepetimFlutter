import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../utils/auth_state.dart';
import '../utils/user_store.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final api = ApiService();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    final user = userSession.value;
    if (user != null) {
      nameCtrl.text = user.name;
      emailCtrl.text = user.email;
      phoneCtrl.text = user.phone ?? "";
    }
  }

  Future<void> _save() async {
    setState(() => loading = true);

    try {
      final res = await api.updateProfile(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
      );

      if (!mounted) return;

      if (res == true) {
        // 🔁 LOCAL USER UPDATE
        final updated = UserSession(
          name: nameCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          phone: phoneCtrl.text.trim(),
          role: userSession.value!.role,
        );

        userSession.value = updated;
        await UserStore.save(updated);

        Navigator.pop(context);
      } else {
        _error("Profil güncellenemedi");
      }
    } catch (e) {
      _error("Bir hata oluştu");
    }

    setState(() => loading = false);
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A9D8F), Color(0xFF52B788)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🔙 Back
          Positioned(
            top: 48,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // 🧾 Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 25,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Profili Düzenle",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Bilgilerini güncelle",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 32),

                    _input("Ad Soyad", nameCtrl, Icons.person_outline),
                    const SizedBox(height: 16),
                    _input("E-posta", emailCtrl, Icons.mail_outline),
                    const SizedBox(height: 16),
                    _input("Telefon", phoneCtrl, Icons.phone_outlined),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A9D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Kaydet",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl,
    IconData icon,
  ) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
