
import '../../domain/class/english_tense_class.dart';
import '../../domain/class/nouns_class.dart';
import '../../domain/class/questions_class.dart';
import '../../domain/class/unit_class.dart';
import '../../domain/class/verbs_class.dart';
import '../../domain/class/adverb_frequency.dart';

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

  static Future<List<AdverbFrequency>> getListAdverbFrequency() async {
    List<AdverbFrequency> listAdverbFrequency = [];
    String responseJson = await rootBundle.loadString('assets/data/adverb_frequency.json');
    listAdverbFrequency = apiAdverbFrequencyFromJson(responseJson).listAdverbFrequency;
    return listAdverbFrequency;
  }

  static Future<List<EnglishTense>> getListEnglishTenses() async {
    String responseJson = await rootBundle.loadString('assets/data/english_tenses.json');
    ApiEnglishTenses apiTenses = apiEnglishTensesFromJson(responseJson);
    return apiTenses.englishTenses;
  }

  static Future<ApiUnit> getUnit3ComeIn() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_3_come_in.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit4ILoveIt() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_4_i_love_it.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit5MondaysAndFunDays() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_5_mondays_and_fun_days.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit6ZoomInZoomOut() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_6_zoom_in_zoom_out.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit7NowIsGood() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_7_now_is_good.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit8YoureGood() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_8_youre_good.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit9PlacesToGo() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_9_places_to_go.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit10GetReady() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_10_get_ready.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit11ColorfulMemories() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_11_colorful_memories.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }

  static Future<ApiUnit> getUnit12StopEatGo() async {
    String responseJson = await rootBundle.loadString('assets/data/unit_12_stop_eat_go.json');
    ApiUnit apiUnit = apiUnitFromJson(responseJson);
    return apiUnit;
  }
}
