import 'dart:convert';
import 'dart:io';

// Copying necessary parts of unit_class.dart to simulate parsing
// In a real app we'd import, but for a standalone script this is often easier if dependencies are complex
// However, since we are in the project, let's try to import if possible, 
// but often relative imports in scripts outside lib/ can be tricky without pub spec setup for scripts.
// Let's just create a self-contained parser verification to be safe and fast.

void main() async {
  try {
    final file = File('/media/jorge/Nuevo vol3/Proyectos/ProyectosJorge/Flutter/appbasicvocabulary/assets/data/unit_8_youre_good.json');
    if (!await file.exists()) {
      print('File not found: ${file.path}');
      return;
    }
    final jsonString = await file.readAsString();
    print('JSON read successfully. Length: ${jsonString.length}');
    
    final jsonMap = json.decode(jsonString);
    print('JSON decoded successfully.');

    // Simulate ApiUnit.fromJson
    final unitMap = jsonMap['unit'];
    if (unitMap == null) throw Exception('Missing "unit" key');
    print('Found "unit" key.');

    // Simulate Lesson parsing (where errors usually are)
    final lessons = unitMap['lessons'] as List;
    print('Found ${lessons.length} lessons.');

    for (var i = 0; i < lessons.length; i++) {
      print('Parsing Lesson $i...');
      parseLesson(lessons[i]);
      print('Lesson $i parsed successfully.');
    }

    final uiScreens = jsonMap['ui_screens'] as List?;
    if (uiScreens != null) {
      print('Found ${uiScreens.length} ui_screens.');
      for (var i = 0; i < uiScreens.length; i++) {
        // Basic check
        if (uiScreens[i]['id'] == null) throw Exception('Screen $i missing id');
      }
    }

    print('SUCCESS: Unit 8 JSON appears valid and parseable structure-wise.');

  } catch (e, stack) {
    print('ERROR: $e');
    print(stack);
  }
}

void parseLesson(Map<String, dynamic> json) {
  // Mimic fields accessed in Lesson.fromJson
  final id = json['id'];
  final title = json['title']; // BilingualText
  
  if (json['vocabulary'] != null) {
      // Logic for vocabulary parsing
      final vocab = json['vocabulary'];
      if (vocab is Map) {
          vocab.forEach((k, v) {
              if (v is List) {
                  // check items
              }
          });
      }
  }

  // Check new fields
  if (json['strategy'] != null) {
     print('  Found strategy...');
     final strategy = json['strategy'] as Map<String, dynamic>;
     strategy.forEach((k, v) {
         if (v['phrases'] == null) throw Exception('Strategy $k missing phrases');
         if (v['note'] == null) throw Exception('Strategy $k missing note');
     });
  }

  if (json['key_quotes_for_use'] != null) {
      print('  Found key_quotes_for_use...');
      final quotes = json['key_quotes_for_use'] as List;
      for (var q in quotes) {
          if (q['speaker'] == null) throw Exception('Quote missing speaker');
          if (q['en'] == null) throw Exception('Quote missing en');
          if (q['es'] == null) throw Exception('Quote missing es');
      }
  }

  if (json['model_comment'] != null) {
       print('  Found model_comment...');
       if (json['model_comment']['en'] == null) throw Exception('model_comment missing en');
  }
}
