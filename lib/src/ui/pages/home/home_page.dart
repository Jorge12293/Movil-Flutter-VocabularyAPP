import 'package:appbasicvocabulary/src/ui/pages/nouns/nouns_page.dart';
import 'package:appbasicvocabulary/src/ui/pages/verbs/verbs_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    functionMenu(String title,int id){
    if(id==1){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerbsPage(id: id, title:title)),
        );
    }
    if(id==2){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerbsPage(id: id, title:title)),
        );
    }
    if(id==3){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NounsPage(id: id, title:title)),
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
        maximumSize: const Size(250, 60), 
        minimumSize: const Size(250, 60), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        )
      ), 
      child: Padding(
        padding: const EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(textBtn,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
          const SizedBox(width: 5),
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
        title: Text('Basic Vocabulary'.toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          btnOptionMenu('Regular Verbs',1),
          btnOptionMenu('Irregular Verbs',2),
          btnOptionMenu('Nouns',3),     
        ],
      ),
      ),
    );
  }
}

