import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/adverb_frequency.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AdverbFrequencyPage extends StatefulWidget {
  final String title;
  const AdverbFrequencyPage({
    required this.title,
    super.key,
  });

  @override
  State<AdverbFrequencyPage> createState() => _AdverbFrequencyPageState();
}

class _AdverbFrequencyPageState extends State<AdverbFrequencyPage> {
  bool loadingData = false;
  List<AdverbFrequency> listAdverbFrequency = [];
  late DateTime _startTime;

  @override
  void initState() {
    _startTime = DateTime.now();
    TTSManager().init();
    loadData();
    super.initState();
  }

  loadData() async {
    loadingData = true;
    setState(() {});
    listAdverbFrequency = await LocalJson.getListAdverbFrequency();
    loadingData = false;
    setState(() {});
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);
    StatisticsManager().saveStudySession('Adverbs', duration.inSeconds);
    super.dispose();
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.quiz, color: theme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvaluationPage(
                    type: EvaluationType.adverb,
                    title: widget.title,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: (loadingData)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listAdverbFrequency.length,
              itemBuilder: (context, index) {
                final adverbFrequency = listAdverbFrequency[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: Duration(milliseconds: index * 100),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listAdverbFrequency[index].adverb.en,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, size: 20),
                              color: theme.primaryColor,
                              onPressed: () {
                                TTSManager().speak(listAdverbFrequency[index].adverb.en);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          listAdverbFrequency[index].adverb.es,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 15),
                        LinearPercentIndicator(
                          animation: true,
                          lineHeight: 25.0,
                          animationDuration: 1500,
                          percent: adverbFrequency.percentage,
                          center: Text(
                            '${(adverbFrequency.percentage * 100).toInt()}%',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          barRadius: const Radius.circular(20),
                          progressColor: theme.primaryColor,
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '"${adverbFrequency.example.en}"',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: theme.textTheme.bodyLarge?.color,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.volume_up_rounded, size: 20),
                                    color: theme.primaryColor,
                                    onPressed: () {
                                      TTSManager().speak(adverbFrequency.example.en);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                adverbFrequency.example.es,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}