// To parse this JSON data, do
//
//     final apiAdverbFrequency = apiAdverbFrequencyFromJson(jsonString);

import 'dart:convert';

ApiAdverbFrequency apiAdverbFrequencyFromJson(String str) => ApiAdverbFrequency.fromJson(json.decode(str));

String apiAdverbFrequencyToJson(ApiAdverbFrequency data) => json.encode(data.toJson());

class ApiAdverbFrequency {
    ApiAdverbFrequency({
        required this.listAdverbFrequency,
    });

    List<AdverbFrequency> listAdverbFrequency;

    factory ApiAdverbFrequency.fromJson(Map<String, dynamic> json) => ApiAdverbFrequency(
        listAdverbFrequency: List<AdverbFrequency>.from(json["adverbsFrequency"].map((x) => AdverbFrequency.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "adverbsFrequency": List<dynamic>.from(listAdverbFrequency.map((x) => x.toJson())),
    };
}

class AdverbFrequency {
    AdverbFrequency({
        required this.percentage,
        required this.adverb,
        required this.example,
    });

    double percentage;
    Adverb adverb;
    Example example;

    factory AdverbFrequency.fromJson(Map<String, dynamic> json) => AdverbFrequency(
        percentage: double.parse(json["percentage"]),
        adverb: Adverb.fromJson(json["adverb"]),
        example: Example.fromJson(json["example"]),
    );

    Map<String, dynamic> toJson() => {
        "percentage": percentage.toString(),
        "adverb": adverb.toJson(),
        "example": example.toJson(),
    };
}

class Adverb {
    Adverb({
        required this.en,
        required this.es,
    });

    String en;
    String es;

    factory Adverb.fromJson(Map<String, dynamic> json) => Adverb(
        en: json["en"],
        es: json["es"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
        "es": es,
    };
}

class Example {
    Example({
        required this.en,
        required this.es,
    });

    String en;
    String es;

    factory Example.fromJson(Map<String, dynamic> json) => Example(
        en: json["en"],
        es: json["es"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
        "es": es,
    };
}