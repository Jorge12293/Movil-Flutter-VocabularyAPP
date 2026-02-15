import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/helpers/utils/colors.dart';
import 'package:appbasicvocabulary/src/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String versionName = '';

  @override
  void initState() {
    loadDataInit();
    super.initState();
  }

  loadDataInit() async {
    final info = await PackageInfo.fromPlatform();
    versionName = info.version;
    setState(() {});
  }

  Widget btnLogin(String textBtn) {
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      duration: const Duration(milliseconds: 1000),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 8,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textBtn,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Decor
          Positioned(
            top: -100,
            right: -100,
            child: FadeInRight(
              duration: const Duration(milliseconds: 1500),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withOpacity(0.1),
                ),
              ),
            ),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 1500),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withOpacity(0.15),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 1000),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black.withOpacity(0.3) : theme.primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ]
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 80,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 1000),
                        child: Column(
                          children: [
                            Text(
                              'INGLES',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: theme.primaryColor,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'GRAMÁTICA BÁSICA',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: isDark ? Colors.white70 : appColorGrey, // Assuming appColorGrey is a constant. Alternatively use theme.textTheme.bodyMedium?.color
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      btnLogin('Empezar'),
                      const SizedBox(height: 20),
                      if (versionName.isNotEmpty)
                        FadeInUp(
                          delay: const Duration(milliseconds: 1000),
                          child: Text(
                            'Versión $versionName',
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white54 : appColorGrey.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}