// ignore_for_file: must_be_immutable
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
import 'package:appbasicvocabulary/src/helpers/utils/colors.dart';
import 'package:flutter/material.dart';

class NounsPage extends StatefulWidget {
  int id;
  String title;
   NounsPage({required this.id,required this.title,super.key});

  @override
  State<NounsPage> createState() => _NounsPageState();
}

class _NounsPageState extends State<NounsPage> {
  bool loadingData = false;
  double withScreen=0;

  List<Noun> listNouns     = [];
  List<Noun> listNounsData = [];
  List<DataRow> listDataRow = [];
  List<Widget> listDataNoun= [];

  final searchController = TextEditingController();
  final verticalScrollController = ScrollController();

  @override
  void initState() {
    loadData();
    searchController.addListener(onChange);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }



  void onChange(){
    String textToSearch=searchController.text;
    List<Noun> listNounAux = <Noun>[];
    if(textToSearch==''){
      listNouns=listNounsData;
    }else{
      for(Noun n in listNounsData) {
        if(
          n.noun!.toUpperCase().contains(textToSearch.toUpperCase()) ||
          n.translation!.toUpperCase().contains(textToSearch.toUpperCase())
        ) {
          listNounAux.add(n);
        }
      }
      listNouns=listNounAux;
    }
    setState(() {});
  }


  loadData() async {
    loadingData = true;
    setState(() {});
    listNouns     = await LocalJson.getListNouns(widget.id);
    listNounsData = await LocalJson.getListNouns(widget.id);
    loadingData = false;
    setState(() {});
  }

  generateRowsData(List<Noun> listNouns){
    listNouns.sort((a, b) => a.noun.toString().compareTo(b.noun.toString()));
    listDataNoun.clear();
    for(var i=0;i<listNouns.length;i++){
      listDataNoun.add(containerItem(listNouns[i].noun.toString(),listNouns[i].translation.toString(),i));
   
    }
    return listDataNoun;
  }

  List<DataRow> generateRow() {
    listNouns.sort((a, b) => a.noun.toString().compareTo(b.noun.toString()));
    listDataRow.clear();
    int count =0;
    for (var element in listNouns) {
      count ++;
      listDataRow.add(
        DataRow(
        selected: (count % 2)==0 ? false : true,  
        color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            return null;  // Use the default value.
        }),
        cells: <DataCell>[
          DataCell(
            Container(
              width: 150,
              child: Text('  ${element.noun}'),
            ),
          ),
          DataCell(
            Text(element.translation.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ));
    }
    return listDataRow;
  }

  Widget containerHeader(String noun, String traduction){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 5),
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(noun.toUpperCase(),
              style: TextStyle(fontWeight:FontWeight.bold)),
              Text(traduction.toUpperCase(),
              style: TextStyle(fontWeight:FontWeight.bold)),
            ],
          )
        )
      ),
    );
  }

  Widget containerItem(String noun, String traduction,int index){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 5),
      child: Card(
        color: (index % 2)==0 
               ? Color.fromARGB(255, 177, 242, 210)
               : Colors.white,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120,
                child: Text(noun,textAlign: TextAlign.start),
              ),
              Container(
                width: 120,
                child: Text(traduction,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start),
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
        : Column(
          children: [
            Container(
                width: withScreen/1.05,
                height: 40,
                margin: const EdgeInsets.only(top: 10,bottom: 10),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Buscar',
                    prefixIcon: const Icon(Icons.search),
                  ),
                )
            ),
            containerHeader('${widget.title}','Traducción'),
            Expanded(
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: Column( children: generateRowsData(listNouns))
              )
            )
            
            //Expanded(child: Column( children: generateRowsData(listNouns)))
            /*
            Expanded(
              child: SingleChildScrollView(
            controller: verticalScrollController,
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                child: Center(
                  child: DataTable(
                  columnSpacing: 10,
                  horizontalMargin: 2,
                  decoration: BoxDecoration(
                      border:Border(
                          right: Divider.createBorderSide(context, width: 5.0),
                          left: Divider.createBorderSide(context, width: 5.0)
                      ), 
                  ),
                  columns:  [
                    DataColumn(
                      label: Text('${widget.title}'),
                    ),
                    DataColumn(
                      label: Text('Traducción'),
                    ),
                  ],
                  rows: generateRow(),
                ),
                )
              )
            )
            )
            */
          ],
      )
    );
  }
}
