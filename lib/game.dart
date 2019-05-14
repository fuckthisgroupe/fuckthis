

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _FlutterGameState createState() => _FlutterGameState();
}

class _FlutterGameState extends State<Game> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        // title: Image(image:AssetImage("images/fuckthis_logo.png",),height: 30.0,fit: BoxFit.fitHeight,),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.grey, onPressed: (){
          Navigator.of(context).pushReplacementNamed("/loginpage");
        }),
      ),
      // body: ,
    );
  }
}