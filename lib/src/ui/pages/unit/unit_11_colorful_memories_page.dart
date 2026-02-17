import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit11ColorfulMemoriesPage extends StatefulWidget {
  final String title;
  const Unit11ColorfulMemoriesPage({super.key, required this.title});

  @override
  State<Unit11ColorfulMemoriesPage> createState() => _Unit11ColorfulMemoriesPageState();
}

class _Unit11ColorfulMemoriesPageState extends State<Unit11ColorfulMemoriesPage> {
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
          await rootBundle.loadString('assets/data/unit_11_colorful_memories.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 11 data: $e');
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
            _buildAdjectivesAndOpposites(),
            _buildWasWereStatements(),
            _buildColorsAndQuestions(),
            _buildUncertaintyAndThinking(),
            _buildEmailWritingTask(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Adjectives & Opposites
  Widget _buildAdjectivesAndOpposites() {
    final vocab = _unitData!['unit']['lessons'][0]['vocabulary'] as Map<String, dynamic>;
    final adjectives = vocab['describing_adjectives'] as List;
    final opposites = vocab['opposites'] as List;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Describing Memories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'ADJECTIVES'),
              Tab(text: 'OPPOSITES'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildVocabList(adjectives),
                _buildVocabList(opposites, isOpposites: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabList(List items, {bool isOpposites = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: isOpposites 
                ? const Icon(Icons.compare_arrows, color: Colors.blue)
                : CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${index + 1}'),
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
  }

  // SCREEN 2: Grammar (Was/Were Statements)
  Widget _buildWasWereStatements() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['was_were_statements'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(grammarData['title']['es'], style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          _buildGrammarCard('Use', [grammarData['use'][0]]),
          
          const Text('Forms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildFormCard('Affirmative', grammarData['forms']['affirmative']),
          _buildFormCard('Negative', grammarData['forms']['negative']),
          
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Quick Rule', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(grammarData['quick_rule']['en'], textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGrammarCard(String title, List content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Divider(),
            ...content.map((c) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['en'], style: const TextStyle(fontSize: 16)),
                Text(c['es'], style: const TextStyle(color: Colors.grey)),
              ],
            )).toList(),
          ],
        ),
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
            if (data.containsKey('patterns')) ...[
              const Text('Patterns:', style: TextStyle(fontWeight: FontWeight.w600)),
              ...(data['patterns'] as List).map((p) => Text('• $p')),
              const SizedBox(height: 12),
            ],
            if (data.containsKey('rule')) ...[
              const Text('Rule:', style: TextStyle(fontWeight: FontWeight.w600)),
              if (data['rule'] is Map) ...[
                 Text(data['rule']['en']),
                 Text(data['rule']['es'], style: const TextStyle(color: Colors.grey)),
              ],
              const SizedBox(height: 12),
            ],
            if (data.containsKey('examples')) ...[
              const Text('Examples:', style: TextStyle(fontWeight: FontWeight.w600)),
              ...(data['examples'] as List).map((e) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${e['en']} (${e['es']})'),
              )),
            ]
          ],
        ),
      ),
    );
  }

  // SCREEN 3: Colors & Questions
  Widget _buildColorsAndQuestions() {
    final lessonData = _unitData!['unit']['lessons'][1] as Map<String, dynamic>;
    final colors = lessonData['vocabulary']['colors'] as List;
    final grammar = lessonData['grammar']['was_were_questions'] as Map<String, dynamic>;
    final drill = lessonData['mini_practice'][0]['items'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Colors', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final colorItem = colors[index];
                final colorName = colorItem['en'].toString().toLowerCase();
                Color c = Colors.grey;
                if (colorName.contains('black')) c = Colors.black;
                else if (colorName.contains('blue')) c = Colors.blue;
                else if (colorName.contains('brown')) c = Colors.brown;
                else if (colorName.contains('gray')) c = Colors.grey;
                else if (colorName.contains('green')) c = Colors.green;
                else if (colorName.contains('orange')) c = Colors.orange;
                else if (colorName.contains('pink')) c = Colors.pink;
                else if (colorName.contains('purple')) c = Colors.purple;
                else if (colorName.contains('red')) c = Colors.red;
                else if (colorName.contains('white')) c = Colors.white;
                else if (colorName.contains('yellow')) c = Colors.yellow;

                return GestureDetector(
                  onTap: () => TTSManager().speak(colorItem['en']),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey.withOpacity(0.3))],
                    ),
                    child: Center(
                      child: Text(
                        colorItem['en'], 
                        style: TextStyle(
                          color: c.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          Text(grammar['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildFormCard('Yes/No Questions', grammar['yes_no_questions']),
          _buildFormCard('Information Questions', grammar['information_questions']), // Adapted reuse, might need check

          const SizedBox(height: 24),
          const Text('Drill Practice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ...drill.map((item) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                 Row(
                   children: [
                     const Text('Q: ', style: TextStyle(fontWeight: FontWeight.bold)),
                     Expanded(child: Text(item['q_en'])),
                   ],
                 ),
                 Row(
                   children: [
                     const Text('A: ', style: TextStyle(fontWeight: FontWeight.bold)),
                     Expanded(child: Text(item['a_en'])),
                   ],
                 ),
                 Align(
                   alignment: Alignment.centerRight,
                   child: IconButton(icon: const Icon(Icons.volume_up), onPressed: () {
                     TTSManager().speak('${item['q_en']} ... ${item['a_en']}');
                   }),
                 )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  // SCREEN 4: Uncertainty & Thinking
  Widget _buildUncertaintyAndThinking() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final uncertainty = lessonData['functional_language']['expressing_uncertainty']['phrases'] as List;
    final thinking = lessonData['strategy']['taking_time_to_think']['phrases'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Expressing Uncertainty', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ...uncertainty.map((item) => ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(height: 40),
        
        const Text('Taking Time to Think', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Card(
          color: Colors.lightBlue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [Icon(Icons.lightbulb), SizedBox(width: 8), Text('Strategy Tip', style: TextStyle(fontWeight: FontWeight.bold))]),
                const SizedBox(height: 8),
                Text(lessonData['strategy']['taking_time_to_think']['tip']['en']),
                Text(lessonData['strategy']['taking_time_to_think']['tip']['es'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        ...thinking.map((item) => ListTile(
          leading: const Icon(Icons.hourglass_empty),
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
      ],
    );
  }

  // SCREEN 5: Email Writing
  Widget _buildEmailWritingTask() {
    final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
    final task = lessonData['writing_task'];
    final skills = lessonData['writing_skills']['paragraphs_topic_sentences'];

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
                  Text(skills['title']['en'], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 8),
                  ...(skills['rules'] as List).map((r) => Text('• ${r['en']}')),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Text('Write your email:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Start with a greeting...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text('See Model Email'),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['model_email']['en'], style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
                    const Divider(),
                    Text(task['model_email']['es'], style: const TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.grey)),
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
