import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit5MondaysAndFunDaysPage extends StatefulWidget {
  final String title;
  const Unit5MondaysAndFunDaysPage({super.key, required this.title});

  @override
  State<Unit5MondaysAndFunDaysPage> createState() => _Unit5MondaysAndFunDaysPageState();
}

class _Unit5MondaysAndFunDaysPageState extends State<Unit5MondaysAndFunDaysPage> with TickerProviderStateMixin {
  Map<String, dynamic>? _unitData;
  bool _isLoading = true;
  late TabController _daysTabController;

  @override
  void initState() {
    super.initState();
    _daysTabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _daysTabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/unit_5_mondays_and_fun_days.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 5 data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_unitData == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('Error loading data')),
      );
    }

    final screens = _unitData!['ui_screens'] as List;

    return DefaultTabController(
      length: screens.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.quiz),
              tooltip: 'Evaluación de Unidad',
              onPressed: () => _startEvaluation(context),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: screens.map((s) => Tab(text: s['title']['en'])).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            _buildDaysTimesVocab(),
            _buildSimplePresentGrammar(),
            _buildTellingTime(),
            _buildQuestionsGrammar(),
            _buildFunctionalLanguage(),
            _buildRoutineReport(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Days & Times Vocabulary
  Widget _buildDaysTimesVocab() {
    final vocabData = _unitData!['unit']['lessons'][0]['vocabulary'] as Map<String, dynamic>;
    final days = vocabData['days'] as List;
    final times = vocabData['times_of_day'] as List;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Days & Times', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        TabBar(
          controller: _daysTabController,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Days', icon: Icon(Icons.calendar_today)),
            Tab(text: 'Times of Day', icon: Icon(Icons.access_time)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _daysTabController,
            children: [
              _buildSimpleList(days),
              _buildSimpleList(times),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleList(List items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item['en'], style: const TextStyle(fontSize: 18)),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        );
      },
    );
  }

  // SCREEN 2: Simple Present Grammar
  Widget _buildSimplePresentGrammar() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['simple_present_statements_he_she_they'] as Map<String, dynamic>;
    final adverbData = _unitData!['unit']['lessons'][0]['grammar']['adverbs_position'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('Rules:', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...(grammarData['rules'] as List).map((r) => Text('• ${r['en']}')),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Text('Examples:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...(grammarData['examples']['affirmative'] as List).map((e) => Text('• ${e['en']} (${e['es']})')),
           const SizedBox(height: 8),
          ...(grammarData['examples']['negative'] as List).map((e) => Text('• ${e['en']} (${e['es']})')),

          const Divider(height: 32),
          Text(adverbData['title']['en'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   ...(adverbData['rules'] as List).map((r) => Text('• ${r['en']}')),
                   const SizedBox(height: 8),
                   const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...(adverbData['examples'] as List).map((e) => Text('• ${e['en']}')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 3: Telling Time
  Widget _buildTellingTime() {
    final vocabData = _unitData!['unit']['lessons'][1]['vocabulary'] as Map<String, dynamic>;
    final times = vocabData['telling_the_time'] as List;
    final ampm = vocabData['am_pm'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Telling the Time', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...times.map((item) => ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(item['time'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             Text(item['en']),
             Text(item['es'], style: const TextStyle(color: Colors.grey)),
          ]),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(),
        const Text('AM / PM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...ampm.map((item) => ListTile(
           title: Text(item['en']),
           subtitle: Text(item['es']),
        )),
      ],
    );
  }

  // SCREEN 4: Questions Grammar
  Widget _buildQuestionsGrammar() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['questions_simple_present'] as Map<String, dynamic>;

    return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(grammarData['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    const Text('Rules:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...(grammarData['rules'] as List).map((r) => Text('• ${r['en']}')),
                    const SizedBox(height: 8),
                    const Text('Formula:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Yes/No: ${grammarData['formula']['yes_no_question']}'),
                    Text('Wh-: ${grammarData['formula']['wh_question']}'),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 16),
           const Text('Examples:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...(grammarData['examples'] as List).map((e) => Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text(e['en']),
              subtitle: Text(e['es']),
              trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(e['en'])),
            ),
          )),
          
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              title: const Text('Common Error', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Incorrect: ${grammarData['common_error']['incorrect_en']}', style: const TextStyle(decoration: TextDecoration.lineThrough)),
                  Text('Correct: ${grammarData['common_error']['correct_en']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(grammarData['common_error']['es']),
                ],
              ),
            ),
          )
         ],
       ),
    );
  }

  // SCREEN 5: Functional Language (Me Too)
  Widget _buildFunctionalLanguage() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final agree = lessonData['functional_language']['showing_you_agree'] as List;
    final common = lessonData['functional_language']['showing_things_in_common'] as List;
    final strategy = lessonData['strategy']['short_answers_with_adverbs'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Showing Agreement', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ...agree.map((item) => ListTile(
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(),
        const Text('Things in Common', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ...common.map((item) => ListTile(
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(),
        const Text('Short Answers with Adverbs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...strategy.map((item) => Card(
           child: ListTile(
             title: Text('Q: ${item['q']['en']}'),
             subtitle: Text('A: ${item['a']['en']} (${item['a']['es']})'),
           ),
        )),
      ],
    );
  }

  // SCREEN 6: Routine Report Writing
  Widget _buildRoutineReport() {
     final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
     final skill = lessonData['writing_skills']['headings_and_lists'];
     final task = lessonData['writing_task'];
     final example = skill['example_report'];

     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Writing a Routine Report', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
            Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text('Rules for Headings & Lists', style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 4),
                   ...(skill['rules'] as List).map((r) => Text('• ${r['en']}')),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 20),
           const Text('Example Report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           Card(
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(example['title']['en'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                   const SizedBox(height: 12),
                   ...(example['sections'] as List).map((section) => Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(section['heading']['en'], style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                       ...(section['items'] as List).asMap().entries.map((entry) => Text('${entry.key + 1}. ${entry.value['en']}')),
                       const SizedBox(height: 8),
                     ],
                   )),
                 ],
               ),
             ),
           ),
           
           const SizedBox(height: 20),
           Text(task['prompt']['en'], style: const TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           const TextField(
             maxLines: 5,
             decoration: InputDecoration(
               hintText: 'My Morning Routine\n1. I get up at...',
               border: OutlineInputBorder(),
             ),
           )
         ],
       ),
     );
  }

  void _startEvaluation(BuildContext context) {
    if (_unitData == null) return;
    
    List<VocabularyItem> unitVocabulary = [];
    try {
      final lessons = _unitData!['unit']['lessons'] as List;
      for (var lesson in lessons) {
        if (lesson['vocabulary'] != null) {
          final vocabMap = lesson['vocabulary'] as Map<String, dynamic>;
          vocabMap.forEach((key, value) {
            if (value is List) {
              for (var item in value) {
                unitVocabulary.add(VocabularyItem(
                  en: item['en'] ?? '', 
                  es: item['es'] ?? '',
                ));
              }
            }
          });
        }
      }
    } catch (e) {
      print('Error extracting vocabulary: $e');
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
