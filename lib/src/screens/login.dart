// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/waves.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/logo.ico"),
        title: Text("VILATOUR", style: TextStyle(color: Colors.black, fontFamily: 'PontanoSans'),
        ),
      ),
      body: Column(
        children: [
          Text("Log IN"),
          Column(
            //EMAIL
            //PASSWORD
          ),
          Row(
              //DOS BOTONES
          ),
          //GOOGLE
          WavesWidget(), //ONDAS
        ],
      ),
    );
  }
}


