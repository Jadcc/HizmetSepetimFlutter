import 'package:flutter/material.dart';
import 'gui/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 👈 ÇOK KRİTİK
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Brand colors (global)
  static const brandPrimary = Color(0xFF2A9D8F);
  static const brandBackground = Color(0xFFF3F7F6);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: brandBackground,
      fontFamily: null,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HizmetSepetim',
      theme: theme,
      home: const MainLayout(),
    );
  }
}
