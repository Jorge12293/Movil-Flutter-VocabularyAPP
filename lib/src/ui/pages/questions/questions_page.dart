// ignore_for_file: must_be_immutable
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
import 'package:appbasicvocabulary/src/domain/class/questions_class.dart';
import 'package:flutter/material.dart';

import '../../../helpers/utils/colors.dart';

class QuestionsPage extends StatefulWidget {
  String title;
  QuestionsPage({required this.title,super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  
  
  bool loadingData = false;
  double withScreen=0;

  List<Questions> listQuestions = [];
  List<Widget> listDataQuestions= [];
  final verticalScrollController = ScrollController();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  loadData() async {
    loadingData = true;
    setState(() {});
    listQuestions    = await LocalJson.getListQuestions();
    loadingData = false;
    setState(() {});
  }

  listDataQuestionsData(List<Questions> listQuestions){
    listDataQuestions.clear();
    for(var i=0;i<listQuestions.length;i++){
      listDataQuestions.add(containerItem(listQuestions[i],i));
    }
    return listDataQuestions;
  }


  Widget containerItem(Questions question, int index){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Card(
        color: (index % 2)==0 
               ? appColorGreenOpacity
               : appSecondaryColor,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10,top: 10,left: 10,right: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text('${question.interrogativePronoun}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
              ),
              Divider(),
              Container(
                width: double.infinity,
                child: Text('${question.meaning}',
                  textAlign: TextAlign.center,style: TextStyle(color: appColorBlackOpacity)),
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...question.example!.map((e) => Container(
                    width:MediaQuery.of(context).size.width*0.4,
                    child: Text(e,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                  )),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...question.exampleTraduction!.map((e) => Container(
                    width:MediaQuery.of(context).size.width*0.4,
                    child: Text(e,style: TextStyle(fontSize: 12))
                  )),
                ],
              ), 
            ],
          )
        )
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    withScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: (loadingData)
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20,top: 10),
            child: Column( children: listDataQuestionsData(listQuestions))
          )
    );
  }


}
