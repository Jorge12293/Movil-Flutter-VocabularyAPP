import 'package:flutter/material.dart';

import '../nouns/nouns_page.dart';
import '../questions/questions_page.dart';
import '../verbs/verbs_page.dart';
import '../adverb_frequency/adverb_frequency_page.dart';
import '../../widgets/buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  functionMenu(String title,int id){
    if(id==1 || id==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerbsPage(id: id, title:title)),
      );
    }
    if(id==3 || id==4 ){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NounsPage(id: id, title:title)),
      );
    }
    if(id==5){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuestionsPage(title:title)),
      );
    }
    if(id==6){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdverbFrequencyPage(title:title)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INGLES GRAMÁTICA'.toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              btnOptionMenu('Verbos Regulares',1,functionMenu),
              btnOptionMenu('Verbos Irregulares',2,functionMenu),
              btnOptionMenu('Sustantivos',3,functionMenu),   
              btnOptionMenu('Adjetivos',4,functionMenu),   
              btnOptionMenu('Preguntas',5,functionMenu),
              btnOptionMenu('Adverbios de Frecuencia',6,functionMenu),   
            ],
          )
        )
      ),
    );
  }
}

