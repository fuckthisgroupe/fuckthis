import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/homepage.dart';
import 'package:flutter_firebase/loginpage.dart';
import 'package:flutter_firebase/signup.dart';
import 'package:flutter_firebase/game.dart';
import 'package:flutter_firebase/people.dart' show People;
//import 'package:firebase_auth/firebase_auth.dart';
void main()=>runApp(FireAuth());

class FireAuth extends StatelessWidget{

  static FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Firebase Auth",
      debugShowCheckedModeBanner: false,
theme: ThemeData(primarySwatch: Colors.blue),
      home:LoginPage(),
      routes: <String,WidgetBuilder>{
        "/userpage":(BuildContext context)=>new Page(),
        "/loginpage":(BuildContext context)=>new LoginPage(),
        "/signup":(BuildContext context)=>new SignUpPage(),
        "/game":(BuildContext context)=>new Game(),
        "/people":(BuildContext context)=>new People(),
      },
    );
  }
}