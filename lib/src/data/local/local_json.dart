//import 'package:flutter/material.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
import 'package:appbasicvocabulary/src/domain/class/questions_class.dart';
import 'package:appbasicvocabulary/src/domain/class/verbs_class.dart';
import 'package:flutter/services.dart';

class LocalJson {

  static Future<List<Verb>> getListVerbs(int id) async {
    List<Verb> listVerb = [];
    String responseJson = '';
    if(id==1){
      responseJson = await rootBundle.loadString('assets/data/regular_verbs.json');
    }
    if (id==2){
      responseJson = await rootBundle.loadString('assets/data/irregular_verbs.json');
    }
    
    ApiVerbs apiVerbs = apiVerbsFromJson(responseJson);
    listVerb = apiVerbs.verbs ?? [];
    return listVerb;
  }

  static Future<List<Noun>> getListNouns(int id) async {
    List<Noun> listNouns = [];
    String responseJson =''; 
    if(id==3){
      responseJson = await rootBundle.loadString('assets/data/nouns.json');
    }
    if(id==4){
      responseJson = await rootBundle.loadString('assets/data/adjectives.json');
    }
    ApiNouns apiNouns = apiNounsFromJson(responseJson);
    listNouns = apiNouns.nouns ?? [];
    return listNouns;
  }

  static Future<List<Questions>> getListQuestions() async {
    List<Questions> listQuestions = [];
    String responseJson = await rootBundle.loadString('assets/data/questions.json');
    listQuestions = questionsFromJson(responseJson);
    return listQuestions;
  }
}
