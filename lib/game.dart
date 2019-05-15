
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/sensor_bloc.dart';
import 'package:flutter_firebase/sensor_bloc.dart' as prefix0;
import 'package:sensors/sensors.dart';


class Game extends StatefulWidget  {
  @override
  _FlutterGameState createState() => _FlutterGameState();
}

class _FlutterGameState extends State<Game> with SingleTickerProviderStateMixin {

  StreamSubscription<bool> shakeSubscriber ;    

  int _shakeCounter;


  @override
  Widget build(BuildContext context) {

    _shakeCounter = 0;

    double _prevY = 1;
    bool _isRising = false;

    // if(shakeSubscriber == null ) {
    //   prefix0.SensorBloc().shakeEvent.listen((_){
    //     print("SHAKE ! *************************");
    //   });
    //   // SensorBloc().shakeEvent.listen((_){
    //   //   print("SHAKE ! *************************");
    //   // });
    // }

    accelerometerEvents.listen((AccelerometerEvent event) {
      // print(event.y);
      if((event.y - _prevY).abs() > 0.2) {
        
        if(event.y > _prevY) {
          // it's going up
          if(!_isRising) {
            _shakeCounter++;
          }
          _isRising = true;
        } else if (event.y < _prevY ) {
          // i's going down
          if(_isRising) {
            _shakeCounter++;
          }
          _isRising = false;
        }
        
        _prevY = event.y;

        print(_shakeCounter);
      }
    });

    return _buildGameScaffold();
  }

  @override
  void dispose() {
    // if(shakeSubscriber != null ) shakeSubscriber.cancel();

    super.dispose();
  }

  Scaffold _buildGameScaffold() {
    return Scaffold(
      appBar: AppBar(
        // title: Image(image:AssetImage("images/fuckthis_logo.png",),height: 30.0,fit: BoxFit.fitHeight,),
        title: Text(_shakeCounter.toString()),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.grey, onPressed: (){
          Navigator.of(context).pushReplacementNamed("/loginpage");
        }),
      ),
      // body: ,
    );
  }

}

