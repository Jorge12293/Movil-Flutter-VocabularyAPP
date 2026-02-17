import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit4ILoveItPage extends StatefulWidget {
  final String title;
  const Unit4ILoveItPage({super.key, required this.title});

  @override
  State<Unit4ILoveItPage> createState() => _Unit4ILoveItPageState();
}

class _Unit4ILoveItPageState extends State<Unit4ILoveItPage> {
  Map<String, dynamic>? _unitData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/unit_4_i_love_it.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 4 data: $e');
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
            _buildTechVocab(),
            _buildSimplePresentStatements(),
            _buildUsingTechVocab(),
            _buildYesNoQuestions(),
            _buildFunctionalLanguage(),
            _buildProductReview(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Technology Vocabulary
  Widget _buildTechVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['technology'] as List;
    return _buildVocabListScreen('Technology', vocabList, Icons.devices);
  }

  Widget _buildVocabListScreen(String title, List items, IconData icon) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  title: Text(item['en'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text(item['es'], style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => TTSManager().speak(item['en']),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // SCREEN 2: Simple Present Statements
  Widget _buildSimplePresentStatements() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['simple_present_statements_i_you_we'] as Map<String, dynamic>;
    final patterns = _unitData!['unit']['lessons'][0]['sentence_patterns'][0]['templates'] as List;

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
                   Text('Affirmative: ${grammarData['formula']['affirmative']}'),
                   Text('Negative: ${grammarData['formula']['negative']}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Text('Examples:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...(grammarData['examples']['affirmative'] as List).map((e) => Text('• ${e['en']}')),
          ...(grammarData['examples']['negative'] as List).map((e) => Text('• ${e['en']}')),

          const Divider(height: 32),
          const Text('Sentence Patterns:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...patterns.map((p) => ListTile(
            dense: true,
            title: Text(p['en'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(p['es']),
            // trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(p['en'])), // Optional
          )),
        ],
      ),
    );
  }

  // SCREEN 3: Using Tech Vocabulary
  Widget _buildUsingTechVocab() {
    final vocabData = _unitData!['unit']['lessons'][1]['vocabulary'] as Map<String, dynamic>;
    final tech = vocabData['using_technology'] as List;
    final notes = vocabData['prepositions_notes'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Using Technology', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ...tech.map((item) => ListTile(
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(),
        const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...notes.map((item) => Card(
           color: Theme.of(context).colorScheme.surfaceVariant,
           child: ListTile(
             title: Text(item['en']),
             subtitle: Text(item['es']),
           ),
        )),
      ],
    );
  }

  // SCREEN 4: Yes/No Questions
  Widget _buildYesNoQuestions() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['simple_present_yes_no_questions_i_you_we'] as Map<String, dynamic>;
    final conversation = _unitData!['unit']['lessons'][1]['dialogue']['lines'] as List;

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
                    Text(grammarData['formula']['question']),
                    Text(grammarData['formula']['short_answers']),
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
          
          const SizedBox(height: 24),
          const Text('Dialogue:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...conversation.map((line) => ListTile(
             leading: CircleAvatar(child: Text(line['speaker'][0])),
             title: Text(line['en']),
             subtitle: Text(line['es']),
             trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(line['en'])),
           ))
          ],
        ),
    );
  }

  // SCREEN 5: Functional Language (What about you?)
  Widget _buildFunctionalLanguage() {
    final lessonData = _unitData!['unit']['lessons'][2]['functional_language'] as Map<String, dynamic>;
    final newTopic = lessonData['asking_about_a_new_topic'] as List;
    final askBack = lessonData['asking_back_same_question'] as List;
    final listening = lessonData['showing_you_are_listening'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Starting a New Topic', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...newTopic.map((item) => ListTile(title: Text(item['en']), subtitle: Text(item['es']))),
        
        const Divider(),
        const Text('Asking Back (And you?)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...askBack.map((item) => ListTile(title: Text(item['en']), subtitle: Text(item['es']))),
        
        const Divider(),
        const Text('Listening Responses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...listening.map((item) => ListTile(title: Text(item['en']), subtitle: Text(item['es']))),
      ],
    );
  }

  // SCREEN 6: Product Review
  Widget _buildProductReview() {
     final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
     final grammar = lessonData['grammar'];
     final skills = lessonData['writing_skills'];
     
     final reviewTemplate = lessonData['review_template']; 

     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Writing a Product Review', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           _buildGrammarCard('A / An', grammar['a_an']),
           _buildGrammarCard('Adjectives', grammar['adjectives_before_nouns']),
           
           const SizedBox(height: 16),
           const Text('Connectors:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: (skills['but_because']['rules'] as List).map((r) => Text('• ${r['en']}')).toList()))),

           const SizedBox(height: 20),
           const Text('Model Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Text(reviewTemplate['model_review']['en']),
             ),
           ),
           
           const SizedBox(height: 20),
           const Text('Write your own:', style: TextStyle(fontWeight: FontWeight.bold)),
           const TextField(
             maxLines: 5,
             decoration: InputDecoration(
               hintText: 'I review my... It is good because...',
               border: OutlineInputBorder(),
             ),
           )
         ],
       ),
     );
  }

  Widget _buildGrammarCard(String title, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ...(data['rules'] as List).map((r) => Text('• ${r['en']}')),
          ],
        ),
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
