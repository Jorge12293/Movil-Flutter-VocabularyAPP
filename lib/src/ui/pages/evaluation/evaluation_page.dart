import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/adverb_frequency.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
import 'package:appbasicvocabulary/src/domain/class/questions_class.dart';
import 'package:appbasicvocabulary/src/domain/class/verbs_class.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaluationPage extends StatefulWidget {
  final EvaluationType type;
  final int? id;
  final String title;
  final List<dynamic>? preLoadedData;

  const EvaluationPage({
    required this.type,
    required this.title,
    this.id,
    this.preLoadedData,
    super.key,
  });

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  bool loading = true;
  List<dynamic> dataList = [];
  int currentIndex = 0;
  int score = 0;
  bool showResult = false;
  
  // Quiz State
  late dynamic currentItem;
  List<String> options = [];
  String? selectedOption;
  bool answered = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    
    if (widget.preLoadedData != null && widget.preLoadedData!.isNotEmpty) {
      dataList = List.from(widget.preLoadedData!);
    } else {
      switch (widget.type) {
        case EvaluationType.verb:
          dataList = await LocalJson.getListVerbs(widget.id ?? 1);
          break;
        case EvaluationType.noun:
          dataList = await LocalJson.getListNouns(widget.id ?? 3);
          break;
        case EvaluationType.question:
          dataList = await LocalJson.getListQuestions();
          break;
        case EvaluationType.adverb:
          dataList = await LocalJson.getListAdverbFrequency();
          break;
        case EvaluationType.mixed:
           // Fallback if no preLoadedData is passed for mixed
           final verbs = await LocalJson.getListVerbs(1);
           final nouns = await LocalJson.getListNouns(3);
           dataList = [...verbs, ...nouns];
           break;
      }
    }

    if (dataList.isNotEmpty) {
      dataList.shuffle();
      // Take up to 10 items for the quiz
      if (dataList.length > 10) {
        dataList = dataList.sublist(0, 10);
      }
      generateQuestion();
    }
    
    setState(() => loading = false);
  }

  void generateQuestion() {
    if (currentIndex >= dataList.length) {
      StatisticsManager().saveTestResult(score, dataList.length, widget.type);
      setState(() => showResult = true);
      return;
    }

    currentItem = dataList[currentIndex];
    options = [];
    answered = false;
    selectedOption = null;

    String correctAnswer = getCorrectAnswer(currentItem);
    options.add(correctAnswer);

    // Add 3 wrong answers
    List<dynamic> allData = List.from(dataList);
    // Add extra diversity for wrong options if dealing with mixed/small sets
    // In a real app we might want to fetch more "distractors"
    allData.shuffle();
    for (var item in allData) {
      if (options.length >= 4) break;
      String option = getCorrectAnswer(item);
      if (!options.contains(option) && option.isNotEmpty) {
        options.add(option);
      }
    }
    
    // Fill with placeholders if not enough options
    while(options.length < 4) {
       options.add("Option ${options.length + 1}");
    }

    options.shuffle();
  }

  String getQuestionText(dynamic item) {
    if (item is Verb) return item.infinitive ?? '';
    if (item is Noun) return item.noun ?? '';
    if (item is Questions) return item.interrogativePronoun ?? '';
    if (item is AdverbFrequency) return item.adverb.en;
    if (item is VocabularyItem) return item.en;
    
    return '';
  }

  String getCorrectAnswer(dynamic item) {
    if (item is Verb) return item.translation ?? '';
    if (item is Noun) return item.translation ?? '';
    if (item is Questions) return item.meaning ?? '';
    if (item is AdverbFrequency) return item.adverb.es;
    if (item is VocabularyItem) return item.es;

    return '';
  }

  void checkAnswer(String option) {
    if (answered) return;
    
    setState(() {
      answered = true;
      selectedOption = option;
      if (option == getCorrectAnswer(currentItem)) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          currentIndex++;
          generateQuestion();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Evaluación: ${widget.title}'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : showResult
              ? _buildResultView(theme, isDark)
              : _buildQuizView(theme, isDark),
    );
  }

  Widget _buildQuizView(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / dataList.length,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            'Pregunta ${currentIndex + 1} de ${dataList.length}',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          const Spacer(),
          FadeInDown(
            key: ValueKey(currentIndex),
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '¿Qué significa?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getQuestionText(currentItem),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ...options.map((option) {
            Color? btnColor = theme.cardColor;
            Color? textColor = theme.textTheme.bodyLarge?.color;
            
            if (answered) {
              if (option == getCorrectAnswer(currentItem)) {
                btnColor = Colors.green.withOpacity(0.2);
                textColor = Colors.green;
              } else if (option == selectedOption) {
                btnColor = Colors.red.withOpacity(0.2);
                textColor = Colors.red;
              }
            }

            return FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () => checkAnswer(option),
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildResultView(ThemeData theme, bool isDark) {
    double percentage = score / dataList.length;
    Color scoreColor = percentage >= 0.7 ? Colors.green : (percentage >= 0.4 ? Colors.orange : Colors.red);
    String message = percentage >= 0.8 ? '¡Excelente!' : (percentage >= 0.5 ? '¡Bien hecho!' : '¡Sigue practicando!');

    return Center(
      child: FadeInUp(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                percentage >= 0.5 ? Icons.emoji_events_rounded : Icons.school_rounded,
                size: 100,
                color: scoreColor,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tu puntuación',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$score / ${dataList.length}',
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                    score = 0;
                    showResult = false;
                    loadData();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Intentar de nuevo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Volver',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
