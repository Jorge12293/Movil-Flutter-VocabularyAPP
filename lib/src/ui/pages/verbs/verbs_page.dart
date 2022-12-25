// ignore_for_file: must_be_immutable

import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/verbs_class.dart';
import 'package:flutter/material.dart';

class VerbsPage extends StatefulWidget {
  int id;
  String title;
  VerbsPage({required this.id,required this.title,super.key});

  @override
  State<VerbsPage> createState() => _VerbsPageState();
}

class _VerbsPageState extends State<VerbsPage> {
  bool loadingData = false;
  double anchoPantalla=0;

  List<Verb> listVerbs     = [];
  List<Verb> listVerbsData = [];
  List<DataRow> listDataRow = [];

  final searchController = TextEditingController();

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

  loadData() async {
    loadingData = true;
    setState(() {});
    listVerbs     = await LocalJson.getListVerbs(widget.id);
    listVerbsData = await LocalJson.getListVerbs(widget.id);
    loadingData = false;
    setState(() {});
  }


  void onChange(){
    String textToSearch=searchController.text;
    List<Verb> listVerbAux = <Verb>[];
    if(textToSearch==''){
      listVerbs=listVerbsData;
    }else{
      for(Verb v in listVerbsData) {
        if(
          v.infinitive!.toUpperCase().contains(textToSearch.toUpperCase()) ||
          v.simplePast!.toUpperCase().contains(textToSearch.toUpperCase()) ||
          v.pastParticiple!.toUpperCase().contains(textToSearch.toUpperCase()) ||
          v.translation!.toUpperCase().contains(textToSearch.toUpperCase()) 
        ) {
          listVerbAux.add(v);
        }
      }
      listVerbs=listVerbAux;
    }
    setState(() {});
  }


  List<DataRow> generateRow() {
    
    listDataRow.clear();
    int count =0;
    for (var element in listVerbs) {
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
            Text(' ${element.infinitive}'),
          ),
          DataCell(
            Text(element.simplePast.toString()),
          ),
          DataCell(
            Text(element.pastParticiple.toString()),
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

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();
    anchoPantalla = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: (loadingData)
        ? const Center(child: CircularProgressIndicator())
        :Column(
          children: [
            Container(
                width: anchoPantalla/1.05,
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
            Expanded(
              child: SingleChildScrollView(
              controller: verticalScrollController,
              scrollDirection: Axis.vertical,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                  child: DataTable(
                    columnSpacing: 5,
                    horizontalMargin: 1,
                    decoration: BoxDecoration(
                        border:Border(
                            right: Divider.createBorderSide(context, width: 5.0),
                            left: Divider.createBorderSide(context, width: 5.0)
                        ), 
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('Infinitivo'),
                      ),
                      DataColumn(
                        label: Text('Pasado'),
                      ),
                      DataColumn(
                        label: Text('Participio'),
                      ),
                      DataColumn(
                        label: Text('Traducción'),
                      ),
                    ],
                    rows: generateRow(),
                  ))
               )
            )
          ],
        )
    );
  }
}
