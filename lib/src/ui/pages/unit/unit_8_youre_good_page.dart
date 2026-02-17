import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit8YoureGoodPage extends StatefulWidget {
  final String title;
  const Unit8YoureGoodPage({super.key, required this.title});

  @override
  State<Unit8YoureGoodPage> createState() => _Unit8YoureGoodPageState();
}

class _Unit8YoureGoodPageState extends State<Unit8YoureGoodPage> {
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
          await rootBundle.loadString('assets/data/unit_8_youre_good.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 8 data: $e');
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
            _buildSkillsVocab(),
            _buildAbilityGrammar(),
            _buildWorkVocab(),
            _buildPossibilityGrammar(),
            _buildOpinions(),
            _buildCommentWriting(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Skills Vocabulary
  Widget _buildSkillsVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['skills_verbs'] as List;
    return _buildVocabListScreen('Skills & Abilities', vocabList, Icons.brush);
  }

  // SCREEN 3: Work Vocabulary
  Widget _buildWorkVocab() {
    final vocabList = _unitData!['unit']['lessons'][1]['vocabulary']['work_vocab'] as List;
    return _buildVocabListScreen('Work Vocabulary', vocabList, Icons.work);
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

  // SCREEN 2: Grammar (Ability & Well)
  Widget _buildAbilityGrammar() {
    final abilityData = _unitData!['unit']['lessons'][0]['grammar']['can_cant_ability'] as Map<String, dynamic>;
    final wellData = _unitData!['unit']['lessons'][0]['grammar']['well_adverb'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(abilityData['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rules', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(abilityData['rules'] as List).map((r) => Text('• ${r['en']}')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildFormInfo('Affirmative', abilityData['forms']['affirmative']),
          _buildFormInfo('Negative', abilityData['forms']['negative']),
          _buildFormInfo('Question', abilityData['forms']['question']),
          
          const SizedBox(height: 24),
          Text(wellData['title']['en'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...(wellData['rules'] as List).map((r) => Text('• ${r['en']}')),
                  const Divider(),
                  const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(wellData['examples'] as List).map((e) => Text('• ${e['en']}')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildFormInfo(String label, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['en'], style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(data['es'], style: const TextStyle(color: Colors.grey)),
            ],
          )),
        ],
      ),
    );
  }

  // SCREEN 4: Gramamr (Possibility)
  Widget _buildPossibilityGrammar() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['can_cant_possibility'] as Map<String, dynamic>;

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
                   const Text('Use:', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...(grammarData['use'] as List).map((u) => Text('• ${u['en']}')),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Examples', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...(grammarData['examples'] as List).map((e) => Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text(e['en']),
              subtitle: Text(e['es']),
              trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(e['en'])),
            ),
          )),
          
          const SizedBox(height: 16),
          const Text('Question Words', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (grammarData['question_words'] as List).map((q) => Chip(
              label: Text(q['en']),
              backgroundColor: Colors.grey.shade200,
            )).toList(),
          )
        ],
      ),
    );
  }

  // SCREEN 5: Opinions
  Widget _buildOpinions() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final opinions = lessonData['functional_language']['opinions'] as List;
    final strategy = lessonData['strategy']['explain_more'] as Map<String, dynamic>;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Giving Opinions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...opinions.map((item) => ListTile(
          leading: const Icon(Icons.chat_bubble_outline),
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(height: 40),
        
        Text('Strategy: Explain More', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Card(
          color: Colors.purple.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strategy['note']['en']),
                const Divider(),
                ...(strategy['phrases'] as List).map((p) => ListTile(
                  dense: true,
                  title: Text(p['en'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(p['es']),
                  trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(p['en'])),
                ))
              ],
            ),
          ),
        )
      ],
    );
  }

  // SCREEN 6: Comment Writing
  Widget _buildCommentWriting() {
     final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
     final task = lessonData['writing_task'];
     final skill = lessonData['writing_skill']['quotations'];

     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Write an Online Comment', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           Card(
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(skill['title']['en'], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                   const SizedBox(height: 8),
                   ...(skill['rules'] as List).map((r) => Text('• ${r['en']}')),
                   const Divider(),
                   const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...(skill['examples'] as List).map((e) => Padding(
                     padding: const EdgeInsets.only(top: 4),
                     child: Text('${e['en']}'),
                   )),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 20),
           Text(task['en'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           const TextField(
             maxLines: 5,
             decoration: InputDecoration(
               hintText: 'I agree with...',
               border: OutlineInputBorder(),
             ),
           ),

           const SizedBox(height: 20),
           ExpansionTile(
             title: const Text('See Model Comment'),
             children: [
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(16),
                 color: Colors.grey.shade100,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(lessonData['model_comment']['en'], style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
                     const Divider(),
                     Text(lessonData['model_comment']['es'], style: const TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.grey)),
                   ],
                 ),
               )
             ],
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
