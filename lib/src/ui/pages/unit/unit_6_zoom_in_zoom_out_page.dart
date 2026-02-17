import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appbasicvocabulary/src/helpers/utils/tts_manager.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:appbasicvocabulary/src/ui/pages/evaluation/evaluation_page.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

class Unit6ZoomInZoomOutPage extends StatefulWidget {
  final String title;
  const Unit6ZoomInZoomOutPage({super.key, required this.title});

  @override
  State<Unit6ZoomInZoomOutPage> createState() => _Unit6ZoomInZoomOutPageState();
}

class _Unit6ZoomInZoomOutPageState extends State<Unit6ZoomInZoomOutPage> with TickerProviderStateMixin {
  Map<String, dynamic>? _unitData;
  bool _isLoading = true;
  late TabController _natureTabController;

  @override
  void initState() {
    super.initState();
    _natureTabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _natureTabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/unit_6_zoom_in_zoom_out.json');
      final data = json.decode(response);
      setState(() {
        _unitData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Unit 6 data: $e');
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
            _buildCityPlacesVocab(),
            _buildThereIsAreGrammar(),
            _buildNatureVocab(),
            _buildCountNonCountGrammar(),
            _buildDirections(),
            _buildFactSheetWriting(),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: City Places Vocabulary
  Widget _buildCityPlacesVocab() {
    final vocabList = _unitData!['unit']['lessons'][0]['vocabulary']['places_in_cities'] as List;
    return _buildVocabListScreen('Places in Cities', vocabList, Icons.location_city);
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

  // SCREEN 2: There Is/Are Grammar
  Widget _buildThereIsAreGrammar() {
    final grammarData = _unitData!['unit']['lessons'][0]['grammar']['theres_there_are_quantifiers'] as Map<String, dynamic>;

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
                   ...(grammarData['rules'] as List).map((r) => Padding(
                     padding: const EdgeInsets.symmetric(vertical: 4),
                     child: Text('• ${r['en']}'),
                   )),
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
        ],
      ),
    );
  }

  // SCREEN 3: Nature Vocabulary (Tabbed)
  Widget _buildNatureVocab() {
    final natureData = _unitData!['unit']['lessons'][1]['vocabulary']['nature'] as Map<String, dynamic>;
    final water = natureData['water'] as List;
    final land = natureData['land'] as List;
    final plants = natureData['plants'] as List;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Nature Vocabulary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        TabBar(
          controller: _natureTabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Water', icon: Icon(Icons.water)),
            Tab(text: 'Land', icon: Icon(Icons.landscape)),
            Tab(text: 'Plants', icon: Icon(Icons.grass)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _natureTabController,
            children: [
              _buildSimpleList(water),
              _buildSimpleList(land),
              _buildSimpleList(plants),
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

  // SCREEN 4: Count/Non-Count Grammar
  Widget _buildCountNonCountGrammar() {
    final grammarData = _unitData!['unit']['lessons'][1]['grammar']['count_noncount_nouns'] as Map<String, dynamic>;
    final count = grammarData['count_nouns'];
    final noncount = grammarData['noncount_nouns'];

    return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(grammarData['title']['en'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
           _buildNounTypeCard('Count Nouns', count),
           _buildNounTypeCard('Non-Count Nouns', noncount),

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
         ],
       ),
    );
  }

  Widget _buildNounTypeCard(String title, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Divider(),
            Text(data['definition']['en'], style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            const Text('Use with:', style: TextStyle(fontWeight: FontWeight.bold)),
             ...(data['use_with'] as List).map((u) => Text('• ${u['en']}')),
             const SizedBox(height: 8),
             const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
             ...(data['examples'] as List).map((e) => Text('• ${e['en']}')),
          ],
        ),
      ),
    );
  }

  // SCREEN 5: Directions
  Widget _buildDirections() {
    final lessonData = _unitData!['unit']['lessons'][2] as Map<String, dynamic>;
    final asking = lessonData['functional_language']['asking_directions'] as List;
    final giving = lessonData['functional_language']['giving_directions'] as List;
    final checking = lessonData['functional_language']['checking_information'] as List;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Directions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        
        const Text('Asking', style: TextStyle(fontWeight: FontWeight.bold)),
        ...asking.map((item) => ListTile(
          dense: true,
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        const Divider(),

        const Text('Giving', style: TextStyle(fontWeight: FontWeight.bold)),
        ...giving.map((item) => ListTile(
          dense: true,
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
        const Divider(),

        const Text('Checking Info', style: TextStyle(fontWeight: FontWeight.bold)),
        ...checking.map((item) => ListTile(
          dense: true,
          title: Text(item['en']),
          subtitle: Text(item['es']),
          trailing: IconButton(icon: const Icon(Icons.volume_up), onPressed: () => TTSManager().speak(item['en'])),
        )),
      ],
    );
  }

  // SCREEN 6: Fact Sheet Writing
  Widget _buildFactSheetWriting() {
     final lessonData = _unitData!['unit']['lessons'][3] as Map<String, dynamic>;
     final skill = lessonData['writing_skill']['order_of_adjectives'];
     final examples = lessonData['fact_sheet_examples'] as List;

     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text('Writing a Fact Sheet', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           
            Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text('Order of Adjectives', style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 4),
                   ...(skill['rules'] as List).map((r) => Text('• ${r['en']}')),
                 ],
               ),
             ),
           ),

           const SizedBox(height: 20),
           const Text('Model Fact Sheets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ...examples.map((ex) => Card(
             margin: const EdgeInsets.only(top: 8),
             child: Padding(
               padding: const EdgeInsets.all(12),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(ex['title']['en'], style: const TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   Text(ex['content']['en']),
                   const SizedBox(height: 4),
                   Text(ex['content']['es'], style: const TextStyle(color: Colors.grey)),
                 ],
               ),
             ),
           )),
           
           const SizedBox(height: 20),
           const Text('Write your own:', style: TextStyle(fontWeight: FontWeight.bold)),
           const TextField(
             maxLines: 5,
             decoration: InputDecoration(
               hintText: 'Location: ...\nSize: ...\nNature: ...',
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
