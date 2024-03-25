
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../data/local/local_json.dart';
import '../../../domain/class/adverb_frequency.dart';
import '../../../helpers/utils/colors.dart';


class AdverbFrequencyPage extends StatefulWidget {
  String title;
  AdverbFrequencyPage({
    required this.title
  });

  @override
  State<AdverbFrequencyPage> createState() => _AdverbFrequencyPageState();
}

class _AdverbFrequencyPageState extends State<AdverbFrequencyPage> {
  bool loadingData = false;
  double withScreen=0;

  List<AdverbFrequency> listAdverbFrequency= [];
  List<Widget> listDataAdverbFrequency = [];


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
    listAdverbFrequency = await LocalJson.getListAdverbFrequency();
    loadingData = false;
    setState(() {});
  }

  listDataAdverbFrequencyWidget(List<AdverbFrequency> listAdverbFrequency){
    listDataAdverbFrequency.clear();
    for(var i=0;i<listAdverbFrequency.length;i++){
      listDataAdverbFrequency.add(containerItem(listAdverbFrequency[i],i));
    }
    return listDataAdverbFrequency;
  }


  Widget containerItem(AdverbFrequency adverbFrequency, int index){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10,top: 10,left: 10,right: 10),
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${adverbFrequency.adverb.en}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),

              Text('${adverbFrequency.adverb.es}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: appColorGrey)
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: 250,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2500,
                    percent: adverbFrequency.percentage,
                    center: Text('${adverbFrequency.percentage*100} %',style: TextStyle(color: appSecondaryColor,fontWeight: FontWeight.bold)),
                    barRadius: Radius.circular(25),
                    progressColor: appPrimaryColor,
                    backgroundColor: appColorRed,
                  )
                ],
              ),
              SizedBox(height: 5),
              Text('${adverbFrequency.example.en}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
              Text('${adverbFrequency.example.es}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: appColorGrey
                  )
                ),
              ],
          )
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
            child: Column( children: listDataAdverbFrequencyWidget(listAdverbFrequency))
          )
    );
  }

}