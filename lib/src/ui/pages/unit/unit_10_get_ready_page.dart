import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit10GetReadyPage extends StatefulWidget {
  final String title;
  const Unit10GetReadyPage({super.key, required this.title});

  @override
  State<Unit10GetReadyPage> createState() => _Unit10GetReadyPageState();
}

class _Unit10GetReadyPageState extends State<Unit10GetReadyPage> {
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
          await rootBundle.loadString('assets/data/unit_10_get_ready.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 10 data: $e');
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
            _buildGoingOutVocab(),
            _buildGoingToStatements(),
            _buildSeasonsAndClothes(),
            _buildGoingToQuestions(),
            _buildSuggestions(),
            _buildInvitationWriting(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Going Out Vocabulary
  Widget _buildGoingOutVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['going_out'] as List;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Going Out',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vocabList.length,
            itemBuilder: (context, index) {
              final item = vocabList[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple.shade100,
                    child: const Icon(Icons.directions_walk, color: Colors.purple),
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

  // SCREEN 2: Grammar (Be Going To Statements)
  Widget _buildGoingToStatements() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['going_to_statements'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(grammarData['title']['es'], style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Use:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(grammarData['use'][0]['en']),
                  Text(grammarData['use'][0]['es'], style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildFormCard('Affirmative', grammarData['forms']['affirmative']),
          _buildFormCard('Negative', grammarData['forms']['negative']),
          
          const SizedBox(height: 16),
          const Text('Time Expressions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (grammarData['time_expressions'] as List).map((e) => Chip(
              label: Text(e),
              backgroundColor: Colors.grey.shade200,
            )).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildFormCard(String title, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Divider(),
            Text('Pattern: ${data['pattern']}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey)),
            const SizedBox(height: 8),
            const Text('Examples:', style: TextStyle(fontWeight: FontWeight.w600)),
            ...(data['examples'] as List).map((e) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('${e['en']} (${e['es']})'),
            )),
          ],
        ),
      ),
    );
  }

  // SCREEN 3: Seasons & Clothes
  Widget _buildSeasonsAndClothes() {
    final vocabData = _unitData!['unit']['lessons'][1]['vocabulary'] as Map<String, dynamic>;
    final seasons = vocabData['seasons'] as List;
    final clothes = vocabData['clothes'] as List;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Seasons & Clothes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'SEASONS'),
              Tab(text: 'CLOTHES'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildVocabList(seasons, icon: Icons.wb_sunny),
                _buildVocabList(clothes, icon: Icons.checkroom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabList(List items, {required IconData icon}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: Icon(icon, color: Theme.of(context).primaryColor),
            title: Text(item['en'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            subtitle: Text(item['es'], style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => TTSManager().speak(item['en']),
            ),
          ),
        );
      },
    );
  }

  // SCREEN 4: Grammar (Be Going To Questions)
  Widget _buildGoingToQuestions() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['going_to_questions'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rules:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(grammarData['rules'] as List).map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• ${r['en']}'),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildQuestionCard('Yes/No Questions', grammarData['yes_no']),
          _buildQuestionCard('Information Questions', grammarData['information_questions']),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String title, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Divider(),
            if (data.containsKey('patterns')) ...[
              const Text('Patterns:', style: TextStyle(fontWeight: FontWeight.w600)),
              ...(data['patterns'] as List).map((p) => Text('• $p')),
              const SizedBox(height: 12),
            ],
            if (data.containsKey('pattern')) ...[
               const Text('Pattern:', style: TextStyle(fontWeight: FontWeight.w600)),
               Text('• ${data['pattern']}'),
               const SizedBox(height: 12),
            ],
            const Text('Examples:', style: TextStyle(fontWeight: FontWeight.w600)),
            ...(data['examples'] as List).map((e) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('${e['en']} (${e['es']})'),
            )),
            
            if (data.containsKey('short_answers')) ...[
               const SizedBox(height: 12),
               const Text('Short Answers:', style: TextStyle(fontWeight: FontWeight.w600)),
               ...(data['short_answers'] as List).map((a) => Text('${a['en']}')),
            ]
          ],
        ),
      ),
    );
  }

  // SCREEN 5: Suggestions
  Widget _buildSuggestions() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final suggestions = lessonData['functional_language']['suggestions'] as Map<String, dynamic>;
    final strategy = lessonData['strategy']['say_why_cant'] as Map<String, dynamic>;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Suggestions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildListSection('Making Suggestions', suggestions['make'], Icons.add_reaction),
        _buildListSection('Accepting', suggestions['accept'], Icons.check_circle),
        _buildListSection('Refusing Politely', suggestions['refuse_politely'], Icons.cancel),
        
        const Divider(height: 40),
        Text('Strategy: ${strategy['title']['en']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Card(
           color: Theme.of(context).colorScheme.errorContainer,
           child: Padding(
             padding: const EdgeInsets.all(16),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text('Patterns:', style: TextStyle(fontWeight: FontWeight.bold)),
                 ...(strategy['patterns'] as List).map((p) => Text('• ${p['en']}')),
                 const SizedBox(height: 10),
                 const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                 ...(strategy['examples'] as List).map((e) => Text('• ${e['en']}')),
               ],
             ),
           ),
        )
      ],
    );
  }

  Widget _buildListSection(String title, List items, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: items.map((item) => ListTile(
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => TTSManager().speak(item['en']),
          ),
        )).toList(),
      ),
    );
  }

  // SCREEN 6: Invitation Writing
  Widget _buildInvitationWriting() {
    final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
    final task = lessonData['writing_task'];
    final skill = lessonData['writing_skill']['contractions'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill['title']['en'], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 8),
                  Text(skill['rule']['en']),
                  const Divider(),
                  Wrap(
                    spacing: 8,
                    children: (skill['pairs'] as List).map((p) => Chip(
                      label: Text('${p['full']} → ${p['contracted']}'),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    )).toList(),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text('Write your invitation:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TextField(
             maxLines: 6,
             decoration: InputDecoration(
               hintText: 'Include event, time, place, and plans...',
               border: OutlineInputBorder(),
             ),
           ),
          
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text('See Model Invitation'),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['model_invitation']['en'], style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
                    const Divider(),
                    Text(task['model_invitation']['es'], style: const TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.grey)),
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
