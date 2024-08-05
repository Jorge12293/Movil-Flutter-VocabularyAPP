// To parse this JSON data, do
//
//     final apiNouns = apiNounsFromJson(jsonString);

import 'dart:convert';

ApiNouns apiNounsFromJson(String str) => ApiNouns.fromJson(json.decode(str));

String apiNounsToJson(ApiNouns data) => json.encode(data.toJson());

class ApiNouns {
    ApiNouns({
        this.nouns,
    });

    List<Noun>? nouns;

    factory ApiNouns.fromJson(Map<String, dynamic> json) => ApiNouns(
        nouns: List<Noun>.from(json["nouns"].map((x) => Noun.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "nouns": List<dynamic>.from(nouns!.map((x) => x.toJson())),
    };
}

class Noun {
    Noun({
        this.noun,
        this.translation,
    });

    String? noun;
    String? translation;

    factory Noun.fromJson(Map<String, dynamic> json) => Noun(
        noun: json["noun"],
        translation: json["translation"],
    );

    Map<String, dynamic> toJson() => {
        "noun": noun,
        "translation": translation,
    };
}
