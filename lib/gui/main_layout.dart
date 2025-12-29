import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_gate.dart';
import 'booking_screen.dart';
import 'wallet_screen.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const BookingScreen();
      case 2:
        return const WalletScreen();
      case 3:
        return const ProfileGate();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F5),
      body: SafeArea(
        bottom: false,
        child: _buildBody(), // ❌ IndexedStack YOK
      ),
      bottomNavigationBar: _GradientBottomBar(
        currentIndex: currentIndex,
        onChange: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}

class _GradientBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChange;

  const _GradientBottomBar({
    required this.currentIndex,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF2A9D8F), Color(0xFF3FB7A5), Color(0xFF52B788)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _item(Icons.home_rounded, 0),
              _item(Icons.book, 1),
              _item(Icons.wallet, 2),
              _item(Icons.person_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, int index) {
    final selected = currentIndex == index;

    return GestureDetector(
      onTap: () => onChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.all(selected ? 14 : 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: selected ? 30 : 24,
          color: selected ? const Color(0xFF2A9D8F) : Colors.white70,
        ),
      ),
    );
  }
}
