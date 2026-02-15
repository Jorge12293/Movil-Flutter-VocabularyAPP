import 'package:appbasicvocabulary/src/helpers/theme/theme_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/colors.dart';
import 'package:appbasicvocabulary/src/ui/widgets/home_drawer.dart';
import 'package:appbasicvocabulary/src/ui/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // Access theme data
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'GRAMÁTICA',
          style: theme.appBarTheme.titleTextStyle?.copyWith(letterSpacing: 1.5),
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeManager().themeMode,
            builder: (context, themeMode, child) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.white : appColorGrey,
                ),
                onPressed: () {
                  ThemeManager().toggleTheme();
                },
              );
            },
          )
        ],
      ),
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const DashboardWidget(),
          ],
        ),
      ),
    );
  }
}

