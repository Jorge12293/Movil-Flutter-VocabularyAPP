// To parse this JSON data, do
//
//     final apiModel = apiModelFromJson(jsonString);

import 'dart:convert';

ApiVerbs apiVerbsFromJson(String str) => ApiVerbs.fromJson(json.decode(str));

String apiVerbsToJson(ApiVerbs data) => json.encode(data.toJson());

class ApiVerbs {
    ApiVerbs({
        this.verbs,
    });

    List<Verb>? verbs;

    factory ApiVerbs.fromJson(Map<String, dynamic> json) => ApiVerbs(
        verbs: List<Verb>.from(json["verbs"].map((x) => Verb.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "verbs": List<dynamic>.from(verbs!.map((x) => x.toJson())),
    };
}

class Verb {
    Verb({
        this.infinitive,
        this.simplePast,
        this.pastParticiple,
        this.translation,
    });

    String? infinitive;
    String? simplePast;
    String? pastParticiple;
    String? translation;

    factory Verb.fromJson(Map<String, dynamic> json) => Verb(
        infinitive: json["infinitive"],
        simplePast: json["simple_past"],
        pastParticiple: json["past_participle"],
        translation: json["translation"],
    );

    Map<String, dynamic> toJson() => {
        "infinitive": infinitive,
        "simple_past": simplePast,
        "past_participle": pastParticiple,
        "translation": translation,
    };
}
