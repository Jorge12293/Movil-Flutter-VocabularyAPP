// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/verbs_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerbsPage extends StatefulWidget {
  int id;
  String title;
  VerbsPage({required this.id, required this.title, super.key});

  @override
  State<VerbsPage> createState() => _VerbsPageState();
}

class _VerbsPageState extends State<VerbsPage> {
  bool loadingData = false;
  List<Verb> listVerbs = [];
  List<Verb> listVerbsData = [];
  final searchController = TextEditingController();
  late DateTime _startTime;

  @override
  void initState() {
    _startTime = DateTime.now();
    TTSManager().init();
    loadData();
    searchController.addListener(onChange);
    super.initState();
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);
    StatisticsManager().saveStudySession('Verbs', duration.inSeconds);
    searchController.dispose();
    super.dispose();
  }

  loadData() async {
    loadingData = true;
    setState(() {});
    listVerbs = await LocalJson.getListVerbs(widget.id);
    listVerbsData = await LocalJson.getListVerbs(widget.id);
    loadingData = false;
    setState(() {});
  }

  void onChange() {
    String textToSearch = searchController.text;
    List<Verb> listVerbAux = <Verb>[];
    if (textToSearch == '') {
      listVerbs = listVerbsData;
    } else {
      for (Verb v in listVerbsData) {
        if (v.infinitive!.toUpperCase().contains(textToSearch.toUpperCase()) ||
            v.simplePast!.toUpperCase().contains(textToSearch.toUpperCase()) ||
            v.pastParticiple!.toUpperCase().contains(textToSearch.toUpperCase()) ||
            v.translation!.toUpperCase().contains(textToSearch.toUpperCase())) {
          listVerbAux.add(v);
        }
      }
      listVerbs = listVerbAux;
    }
    setState(() {});
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
                    type: EvaluationType.verb,
                    id: widget.id,
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
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar verbo...',
                      hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey),
                      prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: listVerbs.length,
                    itemBuilder: (context, index) {
                      final verb = listVerbs[index];
                      return FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            verb.infinitive ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: theme.textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.volume_up_rounded, size: 20),
                                          color: theme.primaryColor,
                                          onPressed: () {
                                            TTSManager().speak(verb.infinitive ?? '');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      verb.translation ?? '',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PASADO',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          verb.simplePast ?? '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PARTICIPIO',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          verb.pastParticiple ?? '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
