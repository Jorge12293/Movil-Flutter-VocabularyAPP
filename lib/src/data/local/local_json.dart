//import 'package:flutter/material.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
import 'package:appbasicvocabulary/src/domain/class/verbs_class.dart';
import 'package:flutter/services.dart';

class LocalJson {

  static Future<List<Verb>> getListVerbs(int id) async {
    List<Verb> listVerb = [];
    String responseJson = '';
    if(id==1){
      responseJson = await rootBundle.loadString('assets/data/regular_verbs.json');
    }else{
      responseJson = await rootBundle.loadString('assets/data/irregular_verbs.json');
    }
    ApiVerbs apiVerbs = apiVerbsFromJson(responseJson);
    listVerb = apiVerbs.verbs ?? [];
    return listVerb;
  }

  static Future<List<Noun>> getListNouns() async {
    List<Noun> listNouns = [];
    String responseJson = await rootBundle.loadString('assets/data/nouns.json');
    ApiNouns apiNouns = apiNounsFromJson(responseJson);
    listNouns = apiNouns.nouns ?? [];
    return listNouns;
  }
}
