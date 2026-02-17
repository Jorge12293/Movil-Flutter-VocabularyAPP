import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit12StopEatGoPage extends StatefulWidget {
  final String title;
  const Unit12StopEatGoPage({super.key, required this.title});

  @override
  State<Unit12StopEatGoPage> createState() => _Unit12StopEatGoPageState();
}

class _Unit12StopEatGoPageState extends State<Unit12StopEatGoPage> {
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
          await rootBundle.loadString('assets/data/unit_12_stop_eat_go.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 12 data: $e');
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
            _buildSnacksVocabulary(),
            _buildSimplePastGrammar(),
            _buildQuestionsGrammar(),
            _buildFunctionalLanguage(),
            _buildWritingTask(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Vocabulary (Snacks)
  Widget _buildSnacksVocabulary() {
    final vocabData = _unitData!['unit']['lessons'][0]['vocabulary']
        ['snacks_small_meals'] as Map<String, dynamic>;
    
    return DefaultTabController(
      length: vocabData.keys.length,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Snacks & Small Meals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: vocabData.keys.map((k) => Tab(text: k.replaceAll('_', ' ').toUpperCase())).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: vocabData.values.map((items) {
                final list = items as List;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                           child: Text(item['en'][0].toUpperCase()),
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
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 2: Grammar (Simple Past)
  Widget _buildSimplePastGrammar() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']
        ['simple_past_statements'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(grammarData['title']['es'], 
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          
          _buildGrammarSection('Use', grammarData['use'] as List),
          _buildGrammarSection('Affirmative (Regular)', [grammarData['affirmative']['regular']]),
          _buildGrammarSection('Affirmative (Irregular)', [grammarData['affirmative']['irregular']]),
          _buildGrammarSection('Negative', [grammarData['negative']]),
        ],
      ),
    );
  }

  Widget _buildGrammarSection(String title, List items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Divider(),
            ...items.map((item) {
              if (item is Map) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.containsKey('rule_en')) ...[
                      Text(item['rule_en'], style: const TextStyle(fontSize: 16)),
                      Text(item['rule_es'], style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                    ],
                    if (item.containsKey('en')) ...[
                      Text(item['en'], style: const TextStyle(fontSize: 16)),
                      Text(item['es'], style: const TextStyle(color: Colors.grey)),
                       const SizedBox(height: 8),
                    ],
                    if (item.containsKey('examples')) ...[
                      const SizedBox(height: 8),
                      const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...(item['examples'] as List).map((e) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text('• ${e['en']} (${e['es']})'),
                      )),
                    ]
                  ],
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  // SCREEN 3: Grammar (Questions)
  Widget _buildQuestionsGrammar() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar'] as Map<String, dynamic>;
    final questions = grammarData['simple_past_questions'];
    final someAny = grammarData['some_any'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
           Text('Questions & Some/Any', 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           _buildGrammarSection(questions['title']['en'], [questions['yes_no'], questions['information']]),
           _buildGrammarSection(someAny['title']['en'], someAny['rules']),
        ],
      ),
    );
  }

  // SCREEN 4: Functional Language (Roleplay)
  Widget _buildFunctionalLanguage() {
    final funcData = _unitData!['unit']['lessons'][2]['functional_language']
        ['offering_requesting_food_drink'] as Map<String, dynamic>;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('At the Table', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('Offering and Requesting Food/Drink', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        
        _buildRoleplaySection('Offers', funcData['offers'] as List, Icons.handshake),
        _buildRoleplaySection('Requests', funcData['requests'] as List, Icons.record_voice_over),
        _buildRoleplaySection('Responses', funcData['responses'] as List, Icons.chat_bubble),
      ],
    );
  }

  Widget _buildRoleplaySection(String title, List items, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer)),
              ],
            ),
          ),
          ...items.map((item) => ListTile(
            title: Text(item['en'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text(item['es']),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => TTSManager().speak(item['en']),
            ),
          )),
        ],
      ),
    );
  }

  // SCREEN 5: Writing Task
  Widget _buildWritingTask() {
    final taskData = _unitData!['unit']['lessons'][3]['writing_task'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.edit_note, size: 32, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(taskData['title']['en'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(taskData['title']['es'], style: const TextStyle(color: Colors.blueGrey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Must Include:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(taskData['include'] as List).map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text('${i['en']} (${i['es']})')),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  Text('Length: ${taskData['length']['en']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Your Review:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TextField(
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Write your restaurant review here...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text('See Model Review'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(taskData['model_review']['en'], style: const TextStyle(fontSize: 16)),
                    const Divider(),
                    Text(taskData['model_review']['es'], style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
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
