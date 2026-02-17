import 'dart:convert';

ApiEnglishTenses apiEnglishTensesFromJson(String str) =>
    ApiEnglishTenses.fromJson(json.decode(str));

class ApiEnglishTenses {
  ApiEnglishTenses({required this.englishTenses});

  List<EnglishTense> englishTenses;

  factory ApiEnglishTenses.fromJson(Map<String, dynamic> json) =>
      ApiEnglishTenses(
        englishTenses: List<EnglishTense>.from(
            json["englishTenses"].map((x) => EnglishTense.fromJson(x))),
      );
}

class EnglishTense {
  EnglishTense({
    required this.time,
    required this.aspect,
    required this.tense,
    required this.formula,
    required this.keywords,
    required this.examples,
  });

  String time;
  String aspect;
  BilingualText tense;
  TenseFormula formula;
  List<String> keywords;
  TenseExamples examples;

  factory EnglishTense.fromJson(Map<String, dynamic> json) => EnglishTense(
        time: json["time"],
        aspect: json["aspect"],
        tense: BilingualText.fromJson(json["tense"]),
        formula: TenseFormula.fromJson(json["formula"]),
        keywords: List<String>.from(json["keywords"].map((x) => x)),
        examples: TenseExamples.fromJson(json["examples"]),
      );
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

class TenseFormula {
  TenseFormula({
    required this.affirmative,
    required this.negative,
    required this.question,
  });

  String affirmative;
  String negative;
  String question;

  factory TenseFormula.fromJson(Map<String, dynamic> json) => TenseFormula(
        affirmative: json["affirmative"],
        negative: json["negative"],
        question: json["question"],
      );
}

class TenseExamples {
  TenseExamples({
    required this.affirmative,
    required this.negative,
    required this.question,
  });

  BilingualText affirmative;
  BilingualText negative;
  BilingualText question;

  factory TenseExamples.fromJson(Map<String, dynamic> json) => TenseExamples(
        affirmative: BilingualText.fromJson(json["affirmative"]),
        negative: BilingualText.fromJson(json["negative"]),
        question: BilingualText.fromJson(json["question"]),
      );
}
