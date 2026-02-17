import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit7NowIsGoodPage extends StatefulWidget {
  final String title;
  const Unit7NowIsGoodPage({super.key, required this.title});

  @override
  State<Unit7NowIsGoodPage> createState() => _Unit7NowIsGoodPageState();
}

class _Unit7NowIsGoodPageState extends State<Unit7NowIsGoodPage> {
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
          await rootBundle.loadString('assets/data/unit_7_now_is_good.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 7 data: $e');
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
            _buildHouseVocab(),
            _buildPresentContinuousStatements(),
            _buildTransportVocab(),
            _buildPresentContinuousQuestions(),
            _buildSharingNews(),
            _buildBlogWriting(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: House Vocabulary
  Widget _buildHouseVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['activities_around_the_house'] as List;
    return _buildVocabListScreen('Activities Around the House', vocabList, Icons.home);
  }

  // SCREEN 3: Transport Vocabulary
  Widget _buildTransportVocab() {
    final vocabList = _unitData!['unit']['lessons'][1]['vocabulary']['transportation'] as List;
    return _buildVocabListScreen('Transportation', vocabList, Icons.directions_bus);
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

  // SCREEN 2: Present Continuous Statements
  Widget _buildPresentContinuousStatements() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['present_continuous_statements'] as Map<String, dynamic>;
    final spellingData = _unitData!['unit']['lessons'][0]['grammar']['spelling_ing_rules'] as Map<String, dynamic>;

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
          _buildFormInfo('Affirmative', grammarData['form']['affirmative']),
          _buildFormInfo('Negative', grammarData['form']['negative']),

          const SizedBox(height: 24),
           Text(spellingData['title']['en'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   ...(spellingData['rules'] as List).map((r) => Padding(
                     padding: const EdgeInsets.only(bottom: 4),
                     child: Text('• ${r['en']}'),
                   )),
                   const Divider(),
                   const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                   Wrap(
                     spacing: 8,
                     runSpacing: 4,
                     children: (spellingData['examples'] as List).map((e) => Chip(
                       label: Text(e['en']),
                       backgroundColor: Colors.white,
                     )).toList(),
                   )
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

  // SCREEN 4: Present Continuous Questions
  Widget _buildPresentContinuousQuestions() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['present_continuous_questions'] as Map<String, dynamic>;
    final conversation = _unitData!['unit']['lessons'][1]['conversation_templates'][0] as Map<String, dynamic>;

    return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(grammarData['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           _buildStructureCard('Yes/No Questions', grammarData['yes_no_form']),
           _buildStructureCard('Wh- Questions', grammarData['wh_form']),
           _buildStructureCard('Short Answers', grammarData['short_answers']),

           const SizedBox(height: 24),
           Text('Conversation: ${conversation['label']['en']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           Card(
             color: Colors.grey.shade100,
             child: ListView.separated(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: (conversation['turns'] as List).length,
               separatorBuilder: (c, i) => const Divider(height: 1),
               itemBuilder: (context, index) {
                 final turn = conversation['turns'][index];
                 return ListTile(
                   leading: CircleAvatar(child: Text('${index + 1}')),
                   title: Text(turn['en']),
                   subtitle: Text(turn['es']),
                   trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(turn['en'])),
                 );
               },
             ),
           )
         ],
       ),
    );
  }

  Widget _buildStructureCard(String title, List items) {
     return Card(
       margin: const EdgeInsets.only(bottom: 12),
       child: Padding(
         padding: const EdgeInsets.all(12),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
             const Divider(),
             ...items.map((item) => Text('• ${item['en']}')),
           ],
         ),
       ),
     );
  }

  // SCREEN 5: Sharing News
  Widget _buildSharingNews() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final sharing = lessonData['functional_language']['sharing_news_on_phone'] as List;
    final reacting = lessonData['functional_language']['reacting_to_news'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Sharing News on Phone', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
         ...sharing.map((item) => ListTile(
          leading: const Icon(Icons.phone),
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        
        const Divider(height: 40),
        
        const Text('Reacting to News', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
         ...reacting.map((item) => ListTile(
          leading: const Icon(Icons.face),
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
      ],
    );
  }

  // SCREEN 6: Blog Writing
  Widget _buildBlogWriting() {
     final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
     final skill = lessonData['writing_skill']['also_too'];
     final prompt = lessonData['writing_prompt'];
     final examples = lessonData['blog_examples'] as List;

     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(skill['title']['en'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text('Rules', style: TextStyle(fontWeight: FontWeight.bold)),
                   ...(skill['rules'] as List).map((r) => Text('• ${r['en']}')),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 20),
           const Text('Blog Examples', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           SizedBox(
             height: 180,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: examples.length,
               itemBuilder: (context, index) {
                 final blog = examples[index];
                 return Container(
                   width: 250,
                   margin: const EdgeInsets.only(right: 12, top: 8),
                   child: Card(
                     child: Padding(
                       padding: const EdgeInsets.all(12),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Text(blog['title']['en'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            Expanded(child: SingleChildScrollView(
                               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: 
                                 (blog['key_sentences'] as List).map((s) => Text('• ${s['en']}', style: const TextStyle(fontSize: 12))).toList()
                               )
                            ))
                         ],
                       ),
                     ),
                   ),
                 );
               },
             ),
           ),

           const SizedBox(height: 20),
           Text(prompt['en'], style: const TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           const TextField(
             maxLines: 5,
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'I am taking a bus to...'
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
