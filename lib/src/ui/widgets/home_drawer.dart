import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/helpers/utils/menu_options.dart';
import 'package:appbasicvocabulary/src/helpers/utils/user_manager.dart';
import 'package:appbasicvocabulary/src/ui/pages/adverb_frequency/adverb_frequency_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/nouns/nouns_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/profile/profile_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/questions/questions_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/tenses/tenses_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_12_stop_eat_go_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_11_colorful_memories_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_10_get_ready_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_9_places_to_go_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_8_youre_good_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_7_now_is_good_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_6_zoom_in_zoom_out_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_5_mondays_and_fun_days_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_4_i_love_it_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/unit/unit_3_come_in_page.dart';

import 'package:appbasicvocabulary/src/ui/pages/verbs/verbs_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _userManager = UserManager();

  @override
  void initState() {
    super.initState();
    _userManager.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _userManager.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    setState(() {});
  }

  void _navigateToPage(BuildContext context, int id, String title) {
    Navigator.pop(context); // Close the drawer first
    if (id == 1 || id == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerbsPage(id: id, title: title)),
      );
    } else if (id == 3 || id == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NounsPage(id: id, title: title)),
      );
    } else if (id == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuestionsPage(title: title)),
      );
    } else if (id == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdverbFrequencyPage(title: title)),
      );
    } else if (id == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TensesPage(title: title)),
      );
    } else if (id == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit3ComeInPage(title: title)),
      );
    } else if (id == 9) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit4ILoveItPage(title: title)),
      );
    } else if (id == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit5MondaysAndFunDaysPage(title: title)),
      );
    } else if (id == 11) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit6ZoomInZoomOutPage(title: title)),
      );
    } else if (id == 12) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit7NowIsGoodPage(title: title)),
      );
    } else if (id == 13) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit8YoureGoodPage(title: title)),
      );
    } else if (id == 14) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit9PlacesToGoPage(title: title)),
      );
    } else if (id == 15) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit10GetReadyPage(title: title)),
      );
    } else if (id == 16) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit11ColorfulMemoriesPage(title: title)),
      );
    } else if (id == 17) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Unit12StopEatGoPage(title: title)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(seconds: 1),
            child: Stack(
              children: [
                // Gradient Background
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor,
                        theme.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Decorative Icons
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 150,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: Icon(
                    Icons.library_books_rounded,
                    size: 120,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Positioned(
                  right: 40,
                  bottom: 20,
                  child: Icon(
                    Icons.star_rounded,
                    size: 40,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                // Header Content
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: _userManager.avatarPath != null
                        ? FileImage(File(_userManager.avatarPath!))
                        : null,
                    child: _userManager.avatarPath == null
                        ? Icon(Icons.person, size: 40, color: theme.primaryColor)
                        : null,
                  ),
                  accountName: Text(
                    _userManager.userName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    'Bienvenido a Gramática',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ExpansionTile(
                  leading: Icon(Icons.category, color: theme.primaryColor),
                  title: Text(
                    'Temas',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  children: MenuOptions.topics.map((option) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 32, right: 16),
                      leading: Icon(
                        option['icon'] as IconData,
                        color: option['color'] as Color,
                        size: 20,
                      ),
                      title: Text(
                        option['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      onTap: () => _navigateToPage(
                          context, option['id'], option['title']),
                    );
                  }).toList(),
                ),
                ExpansionTile(
                  leading: Icon(Icons.school, color: theme.primaryColor),
                  title: Text(
                    'Unidades',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  children: MenuOptions.units.map((option) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 32, right: 16),
                      leading: Icon(
                        option['icon'] as IconData,
                        color: option['color'] as Color,
                        size: 20,
                      ),
                      title: Text(
                        option['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      onTap: () => _navigateToPage(
                          context, option['id'], option['title']),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Divider(color: theme.dividerColor),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: ListTile(
              leading: Icon(Icons.settings, color: theme.primaryColor),
              title: Text(
                'Configuración',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 500),
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: theme.iconTheme.color),
              title: Text(
                'Salir',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
