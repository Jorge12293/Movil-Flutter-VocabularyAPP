import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit9PlacesToGoPage extends StatefulWidget {
  final String title;
  const Unit9PlacesToGoPage({super.key, required this.title});

  @override
  State<Unit9PlacesToGoPage> createState() => _Unit9PlacesToGoPageState();
}

class _Unit9PlacesToGoPageState extends State<Unit9PlacesToGoPage> {
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
          await rootBundle.loadString('assets/data/unit_9_places_to_go.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 9 data: $e');
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
            _buildTravelVocab(),
            _buildThisTheseGrammar(),
            _buildArrangementsVocab(),
            _buildVerbsGrammar(),
            _buildPricesAndRepeating(),
            _buildImperativesSkill(),
            _buildReviewWriting(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Travel Vocabulary
  Widget _buildTravelVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['travel_vocab'] as List;
    return _buildVocabListScreen('Travel Vocabulary', vocabList, Icons.flight_takeoff);
  }

  // SCREEN 3: Travel Arrangements
  Widget _buildArrangementsVocab() {
    final vocabList = _unitData!['unit']['lessons'][1]['vocabulary']['travel_arrangements'] as List;
    return _buildVocabListScreen('Travel Arrangements', vocabList, Icons.luggage);
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

  // SCREEN 2: Grammar (This/These)
  Widget _buildThisTheseGrammar() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['this_these'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rules', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...(grammarData['rules'] as List).map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• ${r['en']}'),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Forms', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  Text('Singular: ${grammarData['forms']['this_plus_noun']['en']}'),
                  Text(grammarData['forms']['this_plus_noun']['es'], style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text('Plural: ${grammarData['forms']['these_plus_noun']['en']}'),
                  Text(grammarData['forms']['these_plus_noun']['es'], style: const TextStyle(color: Colors.grey)),
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
          ))
        ],
      ),
    );
  }

  // SCREEN 4: Grammar (Like/Want/Need/Have to)
  Widget _buildVerbsGrammar() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['like_want_need_have_to'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(grammarData['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          _buildInfoCard('Meaning', [
             ...grammarData['meaning']['choose'],
             ...grammarData['meaning']['necessary']
          ]),

          _buildInfoCard('Rules', grammarData['rules']),

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
          const Text('Templates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (grammarData['templates'] as List).map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• ${t['en']}', style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                )).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List items) {
     return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
             const Divider(),
             ...items.map((item) => Padding(
               padding: const EdgeInsets.symmetric(vertical: 4),
               child: Text('• ${item['en']}'),
             ))
          ],
        ),
      ),
     );
  }

  // SCREEN 5: Prices & Repeating
  Widget _buildPricesAndRepeating() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final prices = lessonData['functional_language']['asking_info_prices'] as List;
    final repeat = lessonData['strategy']['repeat']['phrases'] as List;
    final tips = lessonData['pronunciation']['prices']['tips'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Asking about Prices', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ...prices.map((p) => ListTile(
          title: Text(p['en']),
          subtitle: Text(p['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(p['en'])),
        )),
        
        const Divider(height: 40),
        const Text('Strategy: Repeating', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ...repeat.map((p) => ListTile(
          title: Text(p['en']),
          subtitle: Text(p['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(p['en'])),
        )),
        
        const Divider(height: 40),
        Card(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [Icon(Icons.lightbulb, color: Colors.green), SizedBox(width: 8), Text('Pronunciation Tips', style: TextStyle(fontWeight: FontWeight.bold))]),
                const SizedBox(height: 8),
                ...tips.map((t) => Text('• ${t['en']}')),
              ],
            ),
          ),
        )
      ],
    );
  }

  // SCREEN 6: Imperatives Skill
  Widget _buildImperativesSkill() {
    final skillData = _unitData!['unit']['lessons'][3]['writing_skill']['imperatives'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skillData['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(skillData['title']['es'], style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rules', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...(skillData['rules'] as List).map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• ${r['en']}'),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Examples', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ...(skillData['examples'] as List).map((e) => Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text(e['en']),
              subtitle: Text(e['es']),
              trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(e['en'])),
            ),
          ))
        ],
      ),
    );
  }

  // SCREEN 7: Review Writing
  Widget _buildReviewWriting() {
     final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
     final task = lessonData['writing_task'];

     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Write a Description/Review', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           Text(task['en'], style: const TextStyle(fontSize: 16)),
           const SizedBox(height: 8),
           Text(task['es'], style: const TextStyle(color: Colors.grey)),
           
           const SizedBox(height: 20),
           const TextField(
             maxLines: 8,
             decoration: InputDecoration(
               hintText: 'Describe a place near your home...',
               border: OutlineInputBorder(),
             ),
           ),

           const SizedBox(height: 20),
           ExpansionTile(
             title: const Text('See Model Review'),
             children: [
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(16),
                 color: Colors.grey.shade100,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(lessonData['model_review']['en'], style: const TextStyle(fontFamily: 'Courier', fontSize: 14)),
                     const Divider(),
                     Text(lessonData['model_review']['es'], style: const TextStyle(fontFamily: 'Courier', fontSize: 13, color: Colors.grey)),
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
