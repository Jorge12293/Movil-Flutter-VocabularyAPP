import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/questions_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsPage extends StatefulWidget {
  final String title;
  const QuestionsPage({required this.title, super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  bool loadingData = false;
  List<Questions> listQuestions = [];
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
    listQuestions = await LocalJson.getListQuestions();
    loadingData = false;
    setState(() {});
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);
    StatisticsManager().saveStudySession('Questions', duration.inSeconds);
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
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz, color: theme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvaluationPage(
                    type: EvaluationType.question,
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
              itemCount: listQuestions.length,
              itemBuilder: (context, index) {
                final question = listQuestions[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: Duration(milliseconds: index * 100),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
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
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.05),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                question.interrogativePronoun ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: theme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                question.meaning ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'EJEMPLO',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        ...?question.example?.map((e) => Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      e,
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                        color: theme.textTheme.bodyLarge?.color,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.volume_up_rounded, size: 20),
                                                    color: theme.primaryColor,
                                                    onPressed: () {
                                                      TTSManager().speak(e);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TRADUCCIÓN',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        ...?question.exampleTraduction?.map((e) => Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                e,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: theme.textTheme.bodyMedium?.color,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
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
