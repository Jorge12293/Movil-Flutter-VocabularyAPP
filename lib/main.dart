import 'package:appbasicvocabulary/src/helpers/theme/theme.dart';
import 'package:appbasicvocabulary/src/helpers/theme/theme_manager.dart';
import 'package:appbasicvocabulary/src/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager().themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'GRAMÁTICA',
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
        );
      },
    );
  }
}

