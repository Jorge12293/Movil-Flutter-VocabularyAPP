import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/english_tense_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TensesPage extends StatefulWidget {
  final String title;
  const TensesPage({required this.title, super.key});

  @override
  State<TensesPage> createState() => _TensesPageState();
}

class _TensesPageState extends State<TensesPage> {
  bool loadingData = false;
  List<EnglishTense> allTenses = [];
  List<EnglishTense> filteredTenses = [];
  String selectedFilter = 'all';
  late DateTime _startTime;

  final Map<String, Color> timeColors = {
    'present': Colors.teal,
    'past': Colors.deepPurple,
    'future': Colors.deepOrange,
  };

  final Map<String, IconData> timeIcons = {
    'present': Icons.access_time_filled,
    'past': Icons.history,
    'future': Icons.rocket_launch,
  };

  @override
  void initState() {
    _startTime = DateTime.now();
    TTSManager().init();
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);
    StatisticsManager().saveStudySession('Tenses', duration.inSeconds);
    super.dispose();
  }

  loadData() async {
    loadingData = true;
    setState(() {});
    allTenses = await LocalJson.getListEnglishTenses();
    filteredTenses = allTenses;
    loadingData = false;
    setState(() {});
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'all') {
        filteredTenses = allTenses;
      } else {
        filteredTenses = allTenses.where((t) => t.time == filter).toList();
      }
    });
  }

  Color _getTimeColor(String time) => timeColors[time] ?? Colors.blueGrey;
  IconData _getTimeIcon(String time) =>
      timeIcons[time] ?? Icons.access_time_filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: theme.appBarTheme.iconTheme,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
            fontSize: 20,
          ),
        ),
      ),
      body: loadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterChips(theme, isDark),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: filteredTenses.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: Duration(milliseconds: index * 80),
                        child: _buildTenseCard(
                            filteredTenses[index], theme, isDark),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChips(ThemeData theme, bool isDark) {
    final filters = [
      {'key': 'all', 'label': 'Todos', 'color': theme.primaryColor},
      {'key': 'present', 'label': '🟢 Present', 'color': Colors.teal},
      {'key': 'past', 'label': '🟣 Past', 'color': Colors.deepPurple},
      {'key': 'future', 'label': '🟠 Future', 'color': Colors.deepOrange},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: filters.map((f) {
            final isSelected = selectedFilter == f['key'];
            final color = f['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilterChip(
                selected: isSelected,
                label: Text(
                  f['label'] as String,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                selectedColor: color,
                backgroundColor:
                    isDark ? Colors.grey[850] : color.withOpacity(0.08),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? color : color.withOpacity(0.3),
                  ),
                ),
                onSelected: (_) => _applyFilter(f['key'] as String),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTenseCard(
      EnglishTense tense, ThemeData theme, bool isDark) {
    final accentColor = _getTimeColor(tense.time);
    final icon = _getTimeIcon(tense.time);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : accentColor.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 0)
                  .copyWith(bottom: 20),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 26),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  tense.tense.en,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 20),
                color: accentColor,
                onPressed: () => TTSManager().speak(tense.tense.en),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              tense.tense.es,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          children: [
            // ── Formula Section ──
            _buildSectionTitle('📐 Fórmula', theme),
            const SizedBox(height: 8),
            _buildFormulaRow('✅', 'Affirmative', tense.formula.affirmative,
                Colors.green, theme, isDark),
            const SizedBox(height: 6),
            _buildFormulaRow('❌', 'Negative', tense.formula.negative,
                Colors.redAccent, theme, isDark),
            const SizedBox(height: 6),
            _buildFormulaRow('❓', 'Question', tense.formula.question,
                Colors.amber.shade700, theme, isDark),

            const SizedBox(height: 16),

            // ── Keywords Section ──
            _buildSectionTitle('🔑 Keywords', theme),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tense.keywords.map((kw) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    kw,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // ── Examples Section ──
            _buildSectionTitle('💬 Ejemplos', theme),
            const SizedBox(height: 8),
            _buildExampleRow('✅', tense.examples.affirmative, Colors.green,
                theme, isDark),
            const SizedBox(height: 8),
            _buildExampleRow('❌', tense.examples.negative, Colors.redAccent,
                theme, isDark),
            const SizedBox(height: 8),
            _buildExampleRow('❓', tense.examples.question,
                Colors.amber.shade700, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildFormulaRow(String emoji, String label, String formula,
      Color color, ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: formula,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleRow(String emoji, BilingualText example, Color color,
      ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.08 : 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        example.en,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => TTSManager().speak(example.en),
                      child: Icon(Icons.volume_up_rounded,
                          size: 18, color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  example.es,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
                    fontStyle: FontStyle.italic,
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
