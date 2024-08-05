
import 'package:flutter/material.dart';

Widget btnOptionMenu(String textBtn,int id,Function functionMenu){
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