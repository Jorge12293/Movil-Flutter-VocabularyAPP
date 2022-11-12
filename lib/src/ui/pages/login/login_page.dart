import 'package:appbasicvocabulary/src/helpers/utils/colors.dart';
import 'package:appbasicvocabulary/src/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
          Text(textBtn,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: appSecondaryColor)),
          const Icon(Icons.fingerprint,size:25,color: appSecondaryColor)
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
                    Icon(Icons.computer_sharp,size:50,color: appPrimaryColor),
                    Text('Riyary Vocabulary',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: appPrimaryColor)),
                  ],
                ),
                btnLogin('START'),
              ],
            ),
          ),
          const Positioned(
            top: 30,
            left: 30,
            child: Icon(Icons.book,color:appPrimaryColor,size: 50)),
          const Positioned(
            top: 30,
            right: 30,
            child: Icon(Icons.book,color:appPrimaryColor,size: 50)),
          const Positioned(
            bottom: 30,
            left: 30,
            child: Icon(Icons.book,color:appPrimaryColor,size: 50)),
          const Positioned(
            bottom: 30,
            right: 30,
            child: Icon(Icons.book,color:appPrimaryColor,size: 50)),
        ],
      ),
    );
  }
}