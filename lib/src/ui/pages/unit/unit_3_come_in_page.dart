import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit3ComeInPage extends StatefulWidget {
  final String title;
  const Unit3ComeInPage({super.key, required this.title});

  @override
  State<Unit3ComeInPage> createState() => _Unit3ComeInPageState();
}

class _Unit3ComeInPageState extends State<Unit3ComeInPage> {
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
          await rootBundle.loadString('assets/data/unit_3_come_in.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 3 data: $e');
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
            _buildRoomsVocab(),
            _buildFurnitureVocab(),
            _buildPossessivesGrammar(),
            _buildItIsGrammar(),
            _buildPracticePrompts(),
            _buildDialogue(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Rooms Vocabulary
  Widget _buildRoomsVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['rooms_in_a_home'] as List;
    return _buildVocabListScreen('Rooms in a Home', vocabList, Icons.home);
  }

  // SCREEN 2: Furniture Vocabulary
  Widget _buildFurnitureVocab() {
    final vocabList = _unitData!['unit']['lessons'][1]['vocabulary']['furniture'] as List;
    return _buildVocabListScreen('Furniture', vocabList, Icons.chair);
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

  // SCREEN 3: Possessives Grammar
  Widget _buildPossessivesGrammar() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar'] as Map<String, dynamic>;
    final adjectives = grammarData['possessive_adjectives'];
    final s = grammarData['possessive_s'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(adjectives['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Table(
                     border: TableBorder.all(color: Colors.grey.shade300),
                     children: [
                       const TableRow(children: [Padding(padding: EdgeInsets.all(8), child: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))), Padding(padding: EdgeInsets.all(8), child: Text('Possessive', style: TextStyle(fontWeight: FontWeight.bold)))]),
                       ...(adjectives['items'] as List).map((item) => TableRow(children: [
                         Padding(padding: const EdgeInsets.all(8), child: Text(item['subject'])),
                         Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['possessive']['en']), Text(item['possessive']['es'], style: const TextStyle(color: Colors.grey, fontSize: 12))])),
                       ])),
                     ],
                   )
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          Text(s['title']['en'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   ...(s['rules'] as List).map((r) => Padding(
                     padding: const EdgeInsets.only(bottom: 8),
                     child: Text('• ${r['pattern']}: ${r['en']}'),
                   )),
                   const Divider(),
                   const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...(s['examples'] as List).map((e) => Text('• ${e['en']} (${e['es']})')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // SCREEN 4: It Is Grammar
  Widget _buildItIsGrammar() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['it_is'] as Map<String, dynamic>;
    final forms = grammarData['forms'] as Map<String, dynamic>;

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
                    _buildFormRow('Affirmative', forms['affirmative']),
                    _buildFormRow('Negative', forms['negative']),
                    _buildFormRow('Question', forms['question']),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 16),
           const Text('Short Answers:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...(forms['short_answers'] as List).map((e) => Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text(e['en']),
              subtitle: Text(e['es']),
              trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(e['en'])),
            ),
          )),
         ],
       ),
    );
  }

  Widget _buildFormRow(String label, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          Text(data['en'], style: const TextStyle(fontSize: 16)),
          Text(data['es'], style: const TextStyle(color: Colors.grey)),
          const Divider(),
        ],
      ),
    );
  }

  // SCREEN 5: Practice Prompts
  Widget _buildPracticePrompts() {
    final prompts = _unitData!['unit']['lessons'][0]['practice_prompts'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Practice', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...prompts.map((item) => Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.edit, size: 48, color: Colors.blue),
                const SizedBox(height: 16),
                Text(item['en'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(item['es'], style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              ],
            ),
          ),
        )),
        const SizedBox(height: 20),
        const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Type your answer here...'
          ),
        )
      ],
    );
  }

  // SCREEN 6: Dialogue
  Widget _buildDialogue() {
     final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>; // This is u3_l4 in JSON
     final dialogue = lessonData['dialogue']['lines'] as List;
     final title = lessonData['dialogue']['title']['en'];

     return ListView(
       padding: const EdgeInsets.all(16),
       children: [
         Text('Dialogue: $title', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
         const SizedBox(height: 16),
         ...dialogue.map((line) => Card(
           margin: const EdgeInsets.only(bottom: 12),
           child: ListTile(
             leading: CircleAvatar(child: Text(line['speaker'][0])),
             title: Text(line['en']),
             subtitle: Text(line['es']),
             trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(line['en'])),
           ),
         ))
       ],
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
