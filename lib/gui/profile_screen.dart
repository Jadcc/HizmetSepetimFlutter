import 'package:flutter/material.dart';

import '../utils/auth_state.dart';
import '../utils/token_store.dart';
import 'editprofile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout() async {
    await TokenStore.clear();
    userSession.value = null;
    authState.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserSession?>(
      valueListenable: userSession,
      builder: (context, user, _) {
        if (user == null) {
          return const SizedBox();
        }

        final bool isSeller = user.role.toUpperCase() == "SATICI";

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A9D8F), Color(0xFF3FB7A5)],
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: Color(0xFF2A9D8F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (isSeller)
                _Item(
                  icon: Icons.storefront,
                  title: "Satıcı Paneli",
                  onTap: () => _soon(context),
                ),

              const SizedBox(height: 12),

              _Item(
                icon: Icons.edit,
                title: "Profili Düzenle",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),

              _Item(
                icon: Icons.location_on,
                title: "Adreslerim",
                onTap: () => _soon(context),
              ),
              _Item(
                icon: Icons.credit_card,
                title: "Ödeme Yöntemleri",
                onTap: () => _soon(context),
              ),
              _Item(
                icon: Icons.local_offer,
                title: "Promosyon",
                onTap: () => _soon(context),
              ),

              const SizedBox(height: 20),

              _Item(
                icon: Icons.logout,
                title: "Çıkış Yap",
                color: Colors.redAccent,
                onTap: _logout,
              ),
            ],
          ),
        );
      },
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Bu özellik yakında 👀")));
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _Item({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black87;

    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: c),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
