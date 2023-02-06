import 'package:appbasicvocabulary/src/ui/pages/nouns/nouns_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/questions/questions_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/verbs/verbs_page.dart';
import 'package:flutter/material.dart';

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
  }

  Widget btnOptionMenu(String textBtn,int id){
    return Padding(
      padding: const EdgeInsets.only(top: 15,bottom: 15),
      child: ElevatedButton(
      onPressed: () {
        functionMenu(textBtn,id);
      },
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(270, 80), 
        minimumSize: const Size(270, 80), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        )
      ), 
      child: Padding(
        padding: const EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            child:Text(textBtn,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.book,size: 30)
        ],
      ),
      )
    ),
    );
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
              btnOptionMenu('Verbos Regulares',1),
              btnOptionMenu('Verbos Irregulares',2),
              btnOptionMenu('Sustantivos',3),   
              btnOptionMenu('Adjetivos',4),   
              btnOptionMenu('Preguntas',5),   
            ],
          )
        )
      ),
    );
  }
}

