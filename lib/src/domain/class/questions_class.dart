import 'dart:convert';

List<Questions> questionsFromJson(String str) => List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
    Questions({
        this.interrogativePronoun,
        this.meaning,
        this.example,
        this.exampleTraduction,
    });

    String? interrogativePronoun;
    String? meaning;
    List<String>? example;
    List<String>? exampleTraduction;

    factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        interrogativePronoun: json["interrogative_pronoun"],
        meaning: json["meaning"],
        example: (json["example"] != null) 
          ? List<String>.from(json["example"].map((x) => x))
          : [],
        exampleTraduction:(json["example_traduction"] != null) 
          ? List<String>.from(json["example_traduction"].map((x) => x))
          : [],
    );

    Map<String, dynamic> toJson() => {
        "interrogative_pronoun": interrogativePronoun,
        "meaning": meaning,
        "example": (example != null)
          ? List<dynamic>.from(example!.map((x) => x))
          : [],
        "example_traduction":(exampleTraduction != null) 
          ? List<dynamic>.from(exampleTraduction!.map((x) => x))
          : [],
    };
}
