// ignore_for_file: must_be_immutable
import 'package:appbasicvocabulary/src/data/local/local_json.dart';
import 'package:appbasicvocabulary/src/domain/class/nouns_class.dart';
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
  double anchoPantalla=0;

  List<Noun> listNouns     = [];
  List<Noun> listNounsData = [];
  List<DataRow> listDataRow = [];

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
    listNouns     = await LocalJson.getListNouns();
    listNounsData = await LocalJson.getListNouns();
    loadingData = false;
    setState(() {});
  }

  List<DataRow> generateRow() {
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
            Text('  ${element.noun}'),
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
    anchoPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: (loadingData)
        ? const Center(child: CircularProgressIndicator())
        : Column(
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
            Expanded(child: SingleChildScrollView(
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
                  columns: const [
                    DataColumn(
                      label: Text('  Noun'),
                    ),
                    DataColumn(
                      label: Text('Translation'),
                    ),
                  ],
                  rows: generateRow(),
                ),
                )
              )
            ))
          ],
      )
    );
  }
}
