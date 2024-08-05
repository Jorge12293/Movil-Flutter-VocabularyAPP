import 'package:appbasicvocabulary/src/helpers/utils/colors.dart';
import 'package:appbasicvocabulary/src/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  String versionName='';

  @override
  void initState() {
    loadDataInit();
    super.initState();
  }

  loadDataInit() async{
    final info = await PackageInfo.fromPlatform();
    versionName = info.version;
    setState(() {});
  }
  
  Widget btnLogin(String textBtn){
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        )
      ), 
      child: Padding(
        padding: const EdgeInsets.only(top: 5,bottom: 5,left: 40,right: 40),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 6),
          Text(textBtn,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: appSecondaryColor)),
          SizedBox(height: 6),
        ],
      ),
      )
    ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column( 
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
            children: [
                Column(
                  children: const [
                    Icon(Icons.book_sharp,size:50,color: appPrimaryColor),
                    SizedBox(height: 6), 
                    Text('INGLES GRAMÁTICA BÁSICA.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 30,color: appPrimaryColor)),
                    

                  ],
                ),
                btnLogin('Empezar'),
                (versionName != '')
                ? Text('Versión: $versionName',
                  style: TextStyle(
                    color: appPrimaryColor,
                    fontWeight: FontWeight.bold))
                : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}