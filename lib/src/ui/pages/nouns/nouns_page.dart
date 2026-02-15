// ignore_for_file: must_be_immutable
import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NounsPage extends StatefulWidget {
  int id;
  String title;
  NounsPage({required this.id, required this.title, super.key});

  @override
  State<NounsPage> createState() => _NounsPageState();
}

class _NounsPageState extends State<NounsPage> {
  bool loadingData = false;
  List<Noun> listNouns = [];
  List<Noun> listNounsData = [];
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
    StatisticsManager().saveStudyTime(duration.inSeconds);
    searchController.dispose();
    super.dispose();
  }

  void onChange() {
    String textToSearch = searchController.text;
    List<Noun> listNounAux = <Noun>[];
    if (textToSearch == '') {
      listNouns = listNounsData;
    } else {
      for (Noun n in listNounsData) {
        if (n.noun!.toUpperCase().contains(textToSearch.toUpperCase()) ||
            n.translation!.toUpperCase().contains(textToSearch.toUpperCase())) {
          listNounAux.add(n);
        }
      }
      listNouns = listNounAux;
    }
    setState(() {});
  }

  loadData() async {
    loadingData = true;
    setState(() {});
    listNouns = await LocalJson.getListNouns(widget.id);
    listNounsData = await LocalJson.getListNouns(widget.id);
    loadingData = false;
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
                    type: EvaluationType.noun,
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
                      hintText: 'Buscar sustantivo...',
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
                    itemCount: listNouns.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Text(
                                  listNouns[index].noun!,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                                  color: theme.primaryColor,
                                  onPressed: () {
                                    TTSManager().speak(listNouns[index].noun!);
                                  },
                                ),
                              ],
                            ),
                            subtitle: Text(
                              listNouns[index].translation!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
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
