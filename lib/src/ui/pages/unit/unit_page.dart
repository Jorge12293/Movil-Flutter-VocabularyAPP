import 'package:animate_do/animate_do.dart';
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnitPage extends StatefulWidget {
  final String title;
  final String unitId;
  const UnitPage({required this.title, required this.unitId, super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage>
    with SingleTickerProviderStateMixin {
  bool loadingData = false;
  Unit? unit;
  ApiUnit? apiUnit;
  List<UiScreen>? uiScreens;
  TabController? _tabController;
  late PageController _pageController;
  int _currentPage = 0;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _pageController = PageController();
    TTSManager().init();
    loadData();
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);
    StatisticsManager().saveStudySession(widget.title, duration.inSeconds);
    _tabController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  loadData() async {
    loadingData = true;
    if (mounted) setState(() {});
    
    try {
      if (widget.unitId == 'unit_3') {
        apiUnit = await LocalJson.getUnit3ComeIn();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_4') {
        apiUnit = await LocalJson.getUnit4ILoveIt();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_5') {
        apiUnit = await LocalJson.getUnit5MondaysAndFunDays();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_6') {
        apiUnit = await LocalJson.getUnit6ZoomInZoomOut();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_7' ||
          widget.unitId == 'unit_7_now_is_good') {
        apiUnit = await LocalJson.getUnit7NowIsGood();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_8' ||
          widget.unitId == 'unit_8_youre_good') {
        apiUnit = await LocalJson.getUnit8YoureGood();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_9' ||
          widget.unitId == 'unit_9_places_to_go') {
        apiUnit = await LocalJson.getUnit9PlacesToGo();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_10' ||
          widget.unitId == 'unit_10_get_ready') {
        apiUnit = await LocalJson.getUnit10GetReady();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_11' ||
          widget.unitId == 'unit_11_colorful_memories') {
        apiUnit = await LocalJson.getUnit11ColorfulMemories();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      } else if (widget.unitId == 'unit_12' ||
          widget.unitId == 'unit_12_stop_eat_go') {
        apiUnit = await LocalJson.getUnit12StopEatGo();
        if (apiUnit != null) {
          unit = apiUnit!.unit;
          uiScreens = apiUnit!.uiScreens;
        }
      }

      // Initialize TabController only for legacy units
      if (unit != null && uiScreens == null) {
        int tabCount = 3 + (_readingSamples.isNotEmpty ? 1 : 0);
        _tabController = TabController(length: tabCount, vsync: this);
      }
    } catch (e) {
      print('Error loading data: $e');
    }
    
    loadingData = false;
    if (mounted) setState(() {});
  }

  List<ReadingSample> get _readingSamples {
    if (unit == null) return [];
    return unit!.lessons
        .where((l) => l.readingSamples != null)
        .expand((l) => l.readingSamples!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Only show tabs if we have legacy data and a controller
    final showTabs = !loadingData && unit != null && uiScreens == null && _tabController != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: theme.appBarTheme.iconTheme,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: theme.appBarTheme.titleTextStyle?.color,
                fontSize: 18,
              ),
            ),
            if (unit != null)
              Text(
                unit!.title.es,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: theme.appBarTheme.titleTextStyle?.color
                      ?.withOpacity(0.7),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz),
            tooltip: 'Evaluación de Unidad',
            onPressed: () => _startEvaluation(context),
          ),
        ],
        bottom: showTabs
            ? TabBar(
                controller: _tabController,
                labelColor: theme.primaryColor,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                indicatorColor: theme.primaryColor,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(icon: Icon(Icons.book), text: 'Vocabulary'),
                  Tab(icon: Icon(Icons.school), text: 'Grammar'),
                  Tab(icon: Icon(Icons.chat_bubble), text: 'Dialogue'),
                  if (_readingSamples.isNotEmpty)
                    Tab(icon: Icon(Icons.menu_book_rounded), text: 'Reading'),
                ],
              )
            : null,
      ),
      body: loadingData
          ? const Center(child: CircularProgressIndicator())
          : unit == null
              ? const Center(child: Text('No data'))
              : uiScreens != null
                  ? _buildComponentPageView(theme)
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildVocabularyTab(theme, isDark),
                        _buildGrammarTab(theme, isDark),
                        _buildDialogueTab(theme, isDark),
                        if (_readingSamples.isNotEmpty)
                          _buildReadingTab(theme, isDark),
                      ],
                    ),
    );
  }

  Widget _buildComponentPageView(ThemeData theme) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemCount: uiScreens!.length,
      itemBuilder: (context, index) {
        final screen = uiScreens![index];
        final data = _resolveData(screen.dataSourcePath);
        return _buildComponentPage(screen, data, theme);
      },
    );
  }

  dynamic _resolveData(String path) {
    if (apiUnit == null) return null;
    final parts = path.split('.');
    dynamic current = apiUnit;

    try {
      for (int i = 0; i < parts.length; i++) {
        String part = parts[i];
        if (current == null) return null;

        if (part == 'unit') {
          current = (current as ApiUnit).unit;
        } else if (part.startsWith('lessons[')) {
          final index = int.parse(part.substring(8, part.length - 1));
          current = (current as Unit).lessons[index];
        } else if (part == 'vocabulary') {
          current = (current as Lesson).vocabulary;
        } else if (part == 'grammar') {
          current = (current as Lesson).grammar;
        } else if (part == 'functional_language') {
          current = (current as Lesson).vocabulary;
          // Handle prefixing for functional language if next part exists
          if (current is Map &&
              i + 1 < parts.length &&
              (current as Map).containsKey('functional_${parts[i + 1]}')) {
            current = (current as Map)['functional_${parts[i + 1]}'];
            i++; // Skip next part
          }
        } else if (part == 'writing_skill') {
          current = (current as Lesson).writingSkill;
        } else if (part == 'writing_prompt' || part == 'writing_task') {
          current = (current as Lesson).writingPrompt;
        } else if (part == 'strategy') {
          current = (current as Lesson).strategy;
        } else if (part == 'practice_prompts') {
          current = (current as Lesson).practicePrompts;
        } else if (part == 'sentence_patterns') {
          current = (current as Lesson).sentencePatterns;
        } else {
          if (current is Map) {
            current = current[part];
          } else if (current is List) {
             // Handle list access if needed, though mostly handled by component
             return current; 
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      print('Error resolving path $path: $e');
      return null;
    }
    return current;
  }

  Widget _buildComponentPage(UiScreen screen, dynamic data, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            screen.title.en,
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            screen.title.es,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildComponent(screen.componentSuggestion, data, theme),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: const Text('Previous'),
                )
              else
                const SizedBox(),
              if (_currentPage < uiScreens!.length - 1)
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: const Text('Next'),
                )
              else
                const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildComponent(String type, dynamic data, ThemeData theme) {
    if (data == null) return const Center(child: Text('Data not found'));

    switch (type) {
      case 'VocabularyList':
      case 'VocabularyCards':
      case 'PhraseList':
        if (data is List) {
          return _buildSimpleVocabularyList(data as List<VocabularyItem>);
        }
        break;
      case 'GrammarCards':
        if (data is Map) {
          // Reuse existing _buildGrammarSection logic
          // It expects a key and a map. We pass an empty key or title.
          final isDark = theme.brightness == Brightness.dark;
          return SingleChildScrollView(
              child: _buildGrammarSection('', data, theme, isDark));
        }
        break;
      case 'DialogueBuilder':
        if (data is Map) {
          return _buildDialogueBuilder(
              data as Map<String, List<VocabularyItem>>);
        }
        break;
      case 'DialoguePractice':
      case 'ConversationPractice':
        if (data is Lesson) {
          // Display dialogue/conversation from lesson
          return _buildLessonDialogue(data, theme);
        }
        break;
      case 'RuleExamples':
        if (data is WritingSkill) {
          return _buildWritingSkill(data);
        } else if (data is Map) {
          // Attempt to parse Map as WritingSkill (e.g. well_adverb)
          try {
            // Casting generic Map to Map<String, dynamic> safely
            final mapArgs = Map<String, dynamic>.from(data);
            return _buildWritingSkill(WritingSkill.fromMap(mapArgs));
          } catch (e) {
            print('Error parsing RuleExamples from map: $e');
          }
        }
        break;
      case 'WritingComposer':
      case 'ReviewComposer':
      case 'ReportBuilder':
      case 'FactSheetComposer':
        if (data is BilingualText) {
          return _buildWritingComposer(data);
        } else if (data is Lesson && data.writingPrompt != null) {
          return _buildWritingComposer(data.writingPrompt!);
        }
        break;
      case 'ConversationPhrases':
        if (data is List) {
          return _buildSimpleVocabularyList(List<VocabularyItem>.from(data));
        }
        break;
      case 'TabbedVocabulary':
        if (data is Map) {
          return _buildTabbedVocabulary(data as Map<String, List<VocabularyItem>>);
        }
        break;
      case 'TimeCards':
      case 'ChipsAndExamples':
      case 'PromptCards':
        if (data is List) {
          return _buildGenericCards(data, theme);
        }
        break;
      case 'DialoguePlayer':
        if (data is List) {
          return _buildDialoguePlayer(data, theme);
        }
        break;
      case 'FlashcardsWithCategories':
      case 'QuizAndFlashcards':
      case 'QuizAndDrills':
        if (data is Map) {
          return _buildFlashcards(data as Map<String, List<VocabularyItem>>, theme);
        } else if (data is List) {
          return _buildSimpleVocabularyList(List<VocabularyItem>.from(data));
        }
        break;
      case 'RoleplayCards':
        if (data is List) {
          return _buildRoleplayCards(data, theme);
        }
        break;
    }
    return Center(
        child: Text(
            'Unknown component: $type or invalid data type: ${data.runtimeType}'));
  }

  Widget _buildSimpleVocabularyList(List<VocabularyItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(item.en,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.es),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => TTSManager().speak(item.en),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogueBuilder(Map<String, List<VocabularyItem>> data) {
    final functionalItems = <VocabularyItem>[];
    data.forEach((key, value) {
      if (key.startsWith('functional_')) {
        functionalItems.addAll(value);
      }
    });
    return _buildSimpleVocabularyList(functionalItems);
  }

  Widget _buildWritingSkill(WritingSkill skill) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(skill.title.en,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(skill.title.es,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              const Text('Rules:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...skill.rules.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• ${r.en}\n  ${r.es}'),
                  )),
              const SizedBox(height: 16),
              const Text('Examples:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...skill.examples.map((e) => ListTile(
                    title: Text(e.en),
                    subtitle: Text(e.es),
                    trailing: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => TTSManager().speak(e.en),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWritingComposer(BilingualText prompt) {
    return Column(
      children: [
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(prompt.en,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(prompt.es,
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Write your blog post here...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonDialogue(Lesson lesson, ThemeData theme) {
    // Display dialogue or conversation from a lesson
    final items = <Widget>[];
    
    if (lesson.vocabulary != null) {
      lesson.vocabulary!.forEach((category, vocabList) {
        items.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ));
        items.addAll(vocabList.map((item) => ListTile(
          title: Text(item.en),
          subtitle: Text(item.es),
          trailing: IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => TTSManager().speak(item.en),
          ),
        )));
      });
    }
    
    return ListView(children: items);
  }

  Widget _buildTabbedVocabulary(Map<String, List<VocabularyItem>> categories) {
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: categories.keys.map((key) => Tab(text: key)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: categories.values.map((items) => 
                _buildSimpleVocabularyList(items)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericCards(List data, ThemeData theme) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        if (item is VocabularyItem) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(item.en, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.es),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => TTSManager().speak(item.en),
              ),
            ),
          );
        } else if (item is BilingualText) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.en, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.es, style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          );
        }
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(item.toString()),
          ),
        );
      },
    );
  }

  Widget _buildDialoguePlayer(List data, ThemeData theme) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        if (item is BilingualText) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(item.en),
              subtitle: Text(item.es),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => TTSManager().speak(item.en),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildFlashcards(Map<String, List<VocabularyItem>> categories, ThemeData theme) {
    final allItems = <VocabularyItem>[];
    categories.forEach((key, items) {
      allItems.addAll(items);
    });
    
    return PageView.builder(
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        return Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.en,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.es,
                    style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  IconButton(
                    icon: const Icon(Icons.volume_up, size: 48),
                    onPressed: () => TTSManager().speak(item.en),
                  ),
                  const SizedBox(height: 16),
                  Text('${index + 1} / ${allItems.length}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleplayCards(List data, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        if (item is BilingualText) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: theme.primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.theater_comedy, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text('Scenario ${index + 1}', 
                        style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item.en, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(item.es, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => TTSManager().speak(item.en),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }



  Widget _buildVocabularyTab(ThemeData theme, bool isDark) {
    final allVocab = <String, List<VocabularyItem>>{};
    
    for (var lesson in unit!.lessons) {
      if (lesson.vocabulary != null) {
        lesson.vocabulary!.forEach((category, items) {
          if (!allVocab.containsKey(category)) {
            allVocab[category] = [];
          }
          allVocab[category]!.addAll(items);
        });
      }
    }

    if (allVocab.isEmpty) {
      return Center(
        child: Text(
          'No vocabulary available',
          style: GoogleFonts.poppins(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allVocab.keys.length,
      itemBuilder: (context, index) {
        final category = allVocab.keys.elementAt(index);
        final items = allVocab[category]!;
        
        return FadeInUp(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: index * 100),
          child: _buildVocabularyCategory(category, items, theme, isDark),
        );
      },
    );
  }

  Widget _buildVocabularyCategory(String category, List<VocabularyItem> items,
      ThemeData theme, bool isDark) {
    final displayName = category.replaceAll('_', ' ').toUpperCase();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.category, color: Colors.cyan, size: 24),
          ),
          title: Text(
            displayName,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          subtitle: Text(
            '${items.length} words',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          children: items.map((item) {
            return ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              leading: Icon(Icons.circle, size: 8, color: Colors.cyan),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.en,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    color: Colors.cyan,
                    onPressed: () => TTSManager().speak(item.en),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              subtitle: Text(
                item.es,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color,
                  fontStyle: FontStyle.italic,
                ),
              ),
              trailing: item.time != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.time!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    )
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGrammarTab(ThemeData theme, bool isDark) {
    final grammarSections = <Widget>[];

    for (var lesson in unit!.lessons) {
      if (lesson.grammar != null) {
        lesson.grammar!.forEach((key, value) {
          grammarSections.add(_buildGrammarSection(key, value, theme, isDark));
        });
      }
    }

    if (grammarSections.isEmpty) {
      return Center(
        child: Text(
          'No grammar available',
          style: GoogleFonts.poppins(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grammarSections,
    );
  }

  Widget _buildGrammarSection(
      String key, dynamic value, ThemeData theme, bool isDark) {
    final title = value['title'] != null
        ? BilingualText.fromJson(value['title'])
        : BilingualText(en: key, es: key);

    // Handle examples - can be either a List or a Map with affirmative/negative keys
    final examples = <GrammarExample>[];
    if (value['examples'] != null) {
      if (value['examples'] is List) {
        // Direct list of examples
        examples.addAll((value['examples'] as List)
            .map((e) => GrammarExample.fromJson(e))
            .toList());
      } else if (value['examples'] is Map) {
        // Map with affirmative/negative keys
        final examplesMap = value['examples'] as Map;
        if (examplesMap.containsKey('affirmative') && examplesMap['affirmative'] is List) {
          examples.addAll((examplesMap['affirmative'] as List)
              .map((e) => GrammarExample.fromJson(e))
              .toList());
        }
        if (examplesMap.containsKey('negative') && examplesMap['negative'] is List) {
          examples.addAll((examplesMap['negative'] as List)
              .map((e) => GrammarExample.fromJson(e))
              .toList());
        }
      }
    }

    final rules = value['rules'] != null
        ? (value['rules'] as List).map((r) => GrammarRule.fromJson(r)).toList()
        : <GrammarRule>[];

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.en,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        title.es,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Handle sub-sections (like count/non-count nouns in Unit 6)
            if (value.entries.any((e) =>
                e.value is Map &&
                !['title', 'rules', 'examples', 'formula', 'irregular_verbs', 'common_error']
                    .contains(e.key))) ...[
              ...value.entries
                  .where((e) =>
                      e.value is Map &&
                      !['title', 'rules', 'examples', 'formula', 'irregular_verbs', 'common_error']
                          .contains(e.key))
                  .map((e) => _buildGrammarSubSection(e.key, e.value, theme)),
              const SizedBox(height: 16),
            ],
              ...rules.map((rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📌 ', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rule.en,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              Text(
                                rule.es,
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
                  )),

            if (value['formula'] != null)
              _buildFormula(value['formula'], theme),

            if (value['irregular_verbs'] != null &&
                value['irregular_verbs'] is List)
              _buildIrregularVerbs(value['irregular_verbs'], theme),

            if (examples.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💬 Examples',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...examples.map((ex) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ex.en,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    Text(
                                      ex.es,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: theme.textTheme.bodyMedium?.color,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded, size: 18),
                                color: Colors.deepPurple,
                                onPressed: () => TTSManager().speak(ex.en),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
            if (value['common_error'] != null && value['common_error'] is Map)
              _buildCommonError(value['common_error'], theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogueTab(ThemeData theme, bool isDark) {
    final dialogues = unit!.lessons
        .where((lesson) => lesson.dialogue != null)
        .map((lesson) => lesson.dialogue!)
        .toList();

    if (dialogues.isEmpty) {
      return Center(
        child: Text(
          'No dialogue available',
          style: GoogleFonts.poppins(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dialogues.length,
      itemBuilder: (context, index) {
        final dialogue = dialogues[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: _buildDialogueSection(dialogue, theme, isDark),
        );
      },
    );
  }

  Widget _buildDialogueSection(
      Dialogue dialogue, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble, color: Colors.teal, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dialogue.title.en,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      dialogue.title.es,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...dialogue.lines.asMap().entries.map((entry) {
            final line = entry.value;
            final isEven = entry.key % 2 == 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isEven
                        ? Colors.teal.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    child: Text(
                      line.speaker[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: isEven ? Colors.teal : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.speaker,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isEven ? Colors.teal : Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isEven ? Colors.teal : Colors.orange)
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      line.en,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.volume_up_rounded,
                                        size: 18),
                                    color: isEven ? Colors.teal : Colors.orange,
                                    onPressed: () => TTSManager().speak(line.en),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                line.es,
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
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReadingTab(ThemeData theme, bool isDark) {
    if (_readingSamples.isEmpty) {
      return const SizedBox();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _readingSamples.length,
      itemBuilder: (context, index) {
        final sample = _readingSamples[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: isDark ? 2 : 4,
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                        sample.type == 'email'
                            ? Icons.email_rounded
                            : Icons.article_rounded,
                        color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      sample.type.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (sample.enSummary != null) ...[
                  Text(
                    sample.enSummary!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: theme.textTheme.bodyLarge?.color,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sample.esSummary ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormula(dynamic formula, ThemeData theme) {
    if (formula == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.functions, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Formula',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (formula is Map)
            ...formula.entries.map((entry) {
              final key = entry.key.toString().replaceAll('_', ' ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${key[0].toUpperCase()}${key.substring(1)}: ',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.blue[800],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList()
          else
            Text(
              formula.toString(),
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIrregularVerbs(List<dynamic> verbs, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠️ Irregular Verbs',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.orange[800],
            ),
          ),
          const SizedBox(height: 8),
          ...verbs.map((v) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(v['verb'] ?? '',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text('→ ${v['he_she_it'] ?? ''}',
                            style: GoogleFonts.poppins())),
                    Expanded(
                        child: Text('(${v['es'] ?? ''})',
                            style: GoogleFonts.poppins(
                                fontStyle: FontStyle.italic, fontSize: 12))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCommonError(Map<dynamic, dynamic> error, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '❌ Common Error',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.red[800],
            ),
          ),
          const SizedBox(height: 8),
          Text('Incorrect: ${error['incorrect_en'] ?? ''}',
              style: GoogleFonts.poppins(
                  decoration: TextDecoration.lineThrough, color: Colors.red)),
          Text('Correct: ${error['correct_en'] ?? ''}',
              style: GoogleFonts.poppins(
                  color: Colors.green, fontWeight: FontWeight.bold)),
          if (error['es'] != null)
            Text('Note: ${error['es']}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: theme.textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }

  Widget _buildGrammarSubSection(
      String key, Map<dynamic, dynamic> data, ThemeData theme) {
    final title = key.replaceAll('_', ' ').toUpperCase();
    final definition = data['definition'];
    final examples = data['examples'];
    final useWith = data['use_with'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.deepPurple,
            ),
          ),
          if (definition != null) ...[
            const SizedBox(height: 8),
            Text(
              definition['en'] ?? '',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 13),
            ),
            Text(
              definition['es'] ?? '',
              style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color),
            ),
          ],
          if (useWith != null && useWith is List) ...[
            const SizedBox(height: 8),
            Text('Use with:',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 12)),
            ...useWith.map((u) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text('• ${u['en']}', style: GoogleFonts.poppins(fontSize: 12)),
                )),
          ],
          if (examples != null && examples is List) ...[
            const SizedBox(height: 8),
            ...examples.map((ex) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right,
                          size: 16, color: Colors.deepPurple),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex['en'],
                                style: GoogleFonts.poppins(fontSize: 13)),
                            Text(ex['es'],
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  void _startEvaluation(BuildContext context) {
    // Gather all vocabulary from the unit
    List<dynamic> unitVocabulary = [];
    
    if (unit != null) {
      for (var lesson in unit!.lessons) {
        if (lesson.vocabulary != null) {
          lesson.vocabulary!.forEach((_, items) {
            unitVocabulary.addAll(items);
          });
        }
      }
    }

    if (unitVocabulary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay vocabulario suficiente para una evaluación')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationPage(
          type: EvaluationType.mixed,
          title: widget.title,
          preLoadedData: unitVocabulary,
        ),
      ),
    );
  }
}
