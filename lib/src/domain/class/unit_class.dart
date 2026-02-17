import 'dart:convert';

ApiUnit apiUnitFromJson(String str) => ApiUnit.fromJson(json.decode(str));

class ApiUnit {
  ApiUnit({required this.unit, this.uiScreens});

  Unit unit;
  List<UiScreen>? uiScreens;

  factory ApiUnit.fromJson(Map<String, dynamic> json) => ApiUnit(
        unit: Unit.fromJson(json["unit"]),
        uiScreens: json["ui_screens"] != null
            ? List<UiScreen>.from(
                json["ui_screens"].map((x) => UiScreen.fromJson(x)))
            : null,
      );
}

class Unit {
  Unit({
    required this.id,
    required this.title,
    required this.lessons,
    this.overview,
  });

  String id;
  BilingualText title;
  List<Lesson> lessons;
  Overview? overview;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        title: BilingualText.fromJson(json["title"]),
        lessons: List<Lesson>.from(
            json["lessons"].map((x) => Lesson.fromJson(x))),
        overview: json["overview"] != null
            ? Overview.fromJson(json["overview"])
            : null,
      );
}

class Lesson {
  Lesson({
    required this.id,
    required this.title,
    this.vocabulary,
    this.grammar,
    this.dialogue,
    this.reading,
    this.readingSamples,
    this.focus,
    this.sentencePatterns,
    this.practicePrompts,
    this.conversationTemplates,
    this.writingSkill,
    this.blogExamples,
    this.writingPrompt,
    this.strategy,
    this.keyQuotes,
    this.modelComment,
  });

  String id;
  BilingualText title;
  Map<String, List<VocabularyItem>>? vocabulary;
  Map<String, dynamic>? grammar;
  Dialogue? dialogue;
  Reading? reading;
  List<ReadingSample>? readingSamples;
  Focus? focus;
  List<SentencePattern>? sentencePatterns;
  List<PracticePrompt>? practicePrompts;
  List<ConversationTemplate>? conversationTemplates;
  Map<String, WritingSkill>? writingSkill;
  List<BlogExample>? blogExamples;
  BilingualText? writingPrompt;
  Map<String, Strategy>? strategy;
  List<DialogueLine>? keyQuotes;
  BilingualText? modelComment;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    Map<String, WritingSkill>? writingSkillMap;
    if (json["writing_skill"] != null) {
      writingSkillMap = {};
      json["writing_skill"].forEach((key, value) {
        writingSkillMap![key] = WritingSkill.fromMap(value);
      });
    }

    Map<String, List<VocabularyItem>>? vocabMap;
    if (json["vocabulary"] != null) {
      vocabMap = {};
      json["vocabulary"].forEach((key, dynamic value) {
        // Skip non-vocabulary items like prepositions_notes, use_on_phrases, etc.
        if (key == 'prepositions_notes' || 
            key == 'use_on_phrases' ||
            key.contains('_notes') ||
            key.contains('_phrases')) {
          return;
        }
        
        // Only process if value is a List
        if (value is List) {
          try {
            // Check if the first item has 'en' and 'es' fields (vocabulary structure)
            if (value.isNotEmpty &&
                value.first is Map &&
                (value.first as Map).containsKey('en') &&
                (value.first as Map).containsKey('es')) {
              vocabMap![key] = List<VocabularyItem>.from(
                  value.map((x) => VocabularyItem.fromJson(x)));
            }
          } catch (e) {
            // Skip items that can't be parsed as VocabularyItem
            print('Skipping vocabulary category $key: $e');
          }
        } else if (value is Map) {
          // Handle nested vocabulary (e.g. nature -> water, land)
          value.forEach((subKey, subValue) {
            if (subValue is List) {
              try {
                if (subValue.isNotEmpty &&
                    subValue.first is Map &&
                    (subValue.first as Map).containsKey('en') &&
                    (subValue.first as Map).containsKey('es')) {
                  // Flatten key: "nature_water"
                  final compoundKey = '${key}_$subKey';
                  vocabMap![compoundKey] = List<VocabularyItem>.from(
                      subValue.map((x) => VocabularyItem.fromJson(x)));
                }
              } catch (e) {
                print('Skipping nested vocabulary $subKey: $e');
              }
            }
          });
        }
      });
    }

    // Parse functional language as vocabulary categories
    if (json["functional_language"] != null &&
        json["functional_language"] is Map) {
      if (vocabMap == null) vocabMap = {};
      json["functional_language"].forEach((key, value) {
        if (value is List) {
          try {
            if (value.isNotEmpty &&
                value.first is Map &&
                (value.first as Map).containsKey('en') &&
                (value.first as Map).containsKey('es')) {
              // Add functional language with prefix
              final compoundKey = 'functional_$key';
              vocabMap![compoundKey] = List<VocabularyItem>.from(
                  value.map((x) => VocabularyItem.fromJson(x)));
            }
          } catch (e) {
            print('Skipping functional language $key: $e');
          }
        }
      });
    }

    return Lesson(
      id: json["id"],
      title: BilingualText.fromJson(json["title"]),
      vocabulary: vocabMap,
      grammar: json["grammar"],
      dialogue: json["dialogue"] != null
          ? Dialogue.fromJson(json["dialogue"])
          : null,
      reading:
          json["reading"] != null ? Reading.fromJson(json["reading"]) : null,
      readingSamples: json["reading_samples"] != null
          ? List<ReadingSample>.from(
              json["reading_samples"].map((x) => ReadingSample.fromJson(x)))
          : null,
      focus: json["focus"] != null ? Focus.fromJson(json["focus"]) : null,
      sentencePatterns: json["sentence_patterns"] != null
          ? List<SentencePattern>.from(json["sentence_patterns"]
              .map((x) => SentencePattern.fromJson(x)))
          : null,
      practicePrompts: json["practice_prompts"] != null
          ? List<PracticePrompt>.from(
              json["practice_prompts"].map((x) => PracticePrompt.fromJson(x)))
          : null,
      conversationTemplates: json["conversation_templates"] != null
          ? List<ConversationTemplate>.from(json["conversation_templates"]
              .map((x) => ConversationTemplate.fromJson(x)))
          : null,
      writingSkill: writingSkillMap,
      blogExamples: json["blog_examples"] != null
          ? List<BlogExample>.from(
              json["blog_examples"].map((x) => BlogExample.fromJson(x)))
          : null,
      writingPrompt: json["writing_prompt"] != null
          ? BilingualText.fromJson(json["writing_prompt"])
          : json["writing_task"] != null
              ? BilingualText.fromJson(json["writing_task"])
              : null,
      strategy: json["strategy"] != null
          ? (json["strategy"] as Map<String, dynamic>).map((k, v) =>
              MapEntry(k, Strategy.fromJson(v)))
          : null,
      keyQuotes: json["key_quotes_for_use"] != null
          ? List<DialogueLine>.from(json["key_quotes_for_use"]
              .map((x) => DialogueLine.fromJson(x)))
          : null,
      modelComment: json["model_comment"] != null
          ? BilingualText.fromJson(json["model_comment"])
          : null,
    );
  }
}

class BilingualText {
  BilingualText({required this.en, required this.es});

  String en;
  String es;

  factory BilingualText.fromJson(Map<String, dynamic> json) => BilingualText(
        en: json["en"],
        es: json["es"],
      );
}

class VocabularyItem {
  VocabularyItem({required this.en, required this.es, this.time});

  String en;
  String es;
  String? time;

  factory VocabularyItem.fromJson(Map<String, dynamic> json) =>
      VocabularyItem(
        en: json["en"],
        es: json["es"],
        time: json["time"],
      );
}

class Dialogue {
  Dialogue({
    required this.title,
    required this.lines,
  });

  BilingualText title;
  List<DialogueLine> lines;

  factory Dialogue.fromJson(Map<String, dynamic> json) => Dialogue(
        title: BilingualText.fromJson(json["title"]),
        lines: List<DialogueLine>.from(
            json["lines"].map((x) => DialogueLine.fromJson(x))),
      );
}

class DialogueLine {
  DialogueLine({
    required this.speaker,
    required this.en,
    required this.es,
  });

  String speaker;
  String en;
  String es;

  factory DialogueLine.fromJson(Map<String, dynamic> json) => DialogueLine(
        speaker: json["speaker"],
        en: json["en"],
        es: json["es"],
      );
}

class GrammarRule {
  GrammarRule({required this.en, required this.es});

  String en;
  String es;

  factory GrammarRule.fromJson(Map<String, dynamic> json) => GrammarRule(
        en: json["en"],
        es: json["es"],
      );
}

class Reading {
  Reading({required this.title, this.characters, required this.summary});

  BilingualText title;
  List<String>? characters;
  BilingualText summary;

  factory Reading.fromJson(Map<String, dynamic> json) => Reading(
        title: BilingualText.fromJson(json["title"]),
        characters: json["characters"] == null
            ? null
            : List<String>.from(json["characters"].map((x) => x)),
        summary: BilingualText.fromJson(json["summary"]),
      );
}

class ReadingSample {
  ReadingSample({required this.id, required this.type, this.enSummary, this.esSummary});

  String id;
  String type;
  String? enSummary;
  String? esSummary;

  factory ReadingSample.fromJson(Map<String, dynamic> json) => ReadingSample(
        id: json["id"],
        type: json["type"],
        enSummary: json["en_summary"],
        esSummary: json["es_summary"],
      );
}

class GrammarExample {
  GrammarExample({required this.en, required this.es});

  String en;
  String es;

  factory GrammarExample.fromJson(Map<String, dynamic> json) =>
      GrammarExample(
        en: json["en"],
        es: json["es"],
      );
}

class UiScreen {
  UiScreen({
    required this.id,
    required this.title,
    required this.dataSourcePath,
    required this.componentSuggestion,
  });

  String id;
  BilingualText title;
  String dataSourcePath;
  String componentSuggestion;

  factory UiScreen.fromJson(Map<String, dynamic> json) => UiScreen(
        id: json["id"],
        title: BilingualText.fromJson(json["title"]),
        dataSourcePath: json["data_source_path"],
        componentSuggestion: json["component_suggestion"],
      );
}

class Overview {
  Overview({required this.goals});
  List<BilingualText> goals;
  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
        goals: List<BilingualText>.from(
            json["goals"].map((x) => BilingualText.fromJson(x))),
      );
}

class Focus {
  Focus(
      {this.vocabulary,
      this.grammar,
      this.functionalLanguage,
      this.reading,
      this.writing});
  List<String>? vocabulary;
  List<String>? grammar;
  List<String>? functionalLanguage;
  List<String>? reading;
  List<String>? writing;

  factory Focus.fromJson(Map<String, dynamic> json) => Focus(
        vocabulary: json["vocabulary"] != null
            ? List<String>.from(json["vocabulary"])
            : null,
        grammar:
            json["grammar"] != null ? List<String>.from(json["grammar"]) : null,
        functionalLanguage: json["functional_language"] != null
            ? List<String>.from(json["functional_language"])
            : null,
        reading:
            json["reading"] != null ? List<String>.from(json["reading"]) : null,
        writing:
            json["writing"] != null ? List<String>.from(json["writing"]) : null,
      );
}

class SentencePattern {
  SentencePattern(
      {required this.id, required this.label, required this.templates});
  String id;
  BilingualText label;
  List<BilingualText> templates;
  factory SentencePattern.fromJson(Map<String, dynamic> json) =>
      SentencePattern(
        id: json["id"],
        label: BilingualText.fromJson(json["label"]),
        templates: List<BilingualText>.from(
            json["templates"].map((x) => BilingualText.fromJson(x))),
      );
}

class PracticePrompt {
  PracticePrompt({required this.type, required this.en, required this.es});
  String type;
  String en;
  String es;
  factory PracticePrompt.fromJson(Map<String, dynamic> json) => PracticePrompt(
        type: json["type"],
        en: json["en"],
        es: json["es"],
      );
}

class ConversationTemplate {
  ConversationTemplate(
      {required this.id, required this.label, required this.turns});
  String id;
  BilingualText label;
  List<BilingualText> turns;
  factory ConversationTemplate.fromJson(Map<String, dynamic> json) =>
      ConversationTemplate(
        id: json["id"],
        label: BilingualText.fromJson(json["label"]),
        turns: List<BilingualText>.from(
            json["turns"].map((x) => BilingualText.fromJson(x))),
      );
}

class WritingSkill {
  WritingSkill(
      {required this.title, required this.rules, required this.examples});
  BilingualText title;
  List<BilingualText> rules;
  List<BilingualText> examples;
  factory WritingSkill.fromMap(Map<String, dynamic> json) => WritingSkill(
        title: BilingualText.fromJson(json["title"]),
        rules: json["rules"] != null
            ? List<BilingualText>.from(
                json["rules"].map((x) => BilingualText.fromJson(x)))
            : [],
        examples: json["examples"] != null
            ? List<BilingualText>.from(
                json["examples"].map((x) => BilingualText.fromJson(x)))
            : [],
      );
}

class BlogExample {
  BlogExample(
      {required this.id, required this.title, required this.keySentences});
  String id;
  BilingualText title;
  List<BilingualText> keySentences;
  factory BlogExample.fromJson(Map<String, dynamic> json) => BlogExample(
        id: json["id"],
        title: BilingualText.fromJson(json["title"]),
        keySentences: List<BilingualText>.from(
            json["key_sentences"].map((x) => BilingualText.fromJson(x))),
      );
}

class Strategy {
  Strategy({required this.phrases, required this.note});
  List<BilingualText> phrases;
  BilingualText note;

  factory Strategy.fromJson(Map<String, dynamic> json) => Strategy(
        phrases: List<BilingualText>.from(
            json["phrases"].map((x) => BilingualText.fromJson(x))),
        note: BilingualText.fromJson(json["note"]),
      );
}
