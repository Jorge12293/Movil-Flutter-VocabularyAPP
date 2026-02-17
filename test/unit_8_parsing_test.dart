import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:appbasicvocabulary/src/domain/class/unit_class.dart';

void main() {
  test('Unit 8 JSON Parsing Test', () async {
    final file = File('assets/data/unit_8_youre_good.json');
    if (!await file.exists()) {
      fail('JSON file not found at ${file.path}');
    }
    
    final jsonString = await file.readAsString();
    final jsonMap = json.decode(jsonString);

    try {
      final apiUnit = ApiUnit.fromJson(jsonMap);
      
      expect(apiUnit.unit.id, 'unit_8_youre_good');
      expect(apiUnit.uiScreens, isNotNull);
      expect(apiUnit.uiScreens!.length, 8);
      
      final lesson3 = apiUnit.unit.lessons[3];
      expect(lesson3.writingPrompt, isNotNull);
      expect(lesson3.keyQuotes, isNotNull);
      
      print('Unit 8 Parsed Successfully!');
    } catch (e, s) {
      print('Error parsing Unit 8: $e');
      print(s);
      fail('Parsing failed');
    }
  });
}
