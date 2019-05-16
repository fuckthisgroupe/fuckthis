
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';


class Game extends StatefulWidget  {
  @override
  _FlutterGameState createState() => _FlutterGameState();
}

class _FlutterGameState extends State<Game> with SingleTickerProviderStateMixin {
  

  int _shakeCounter;
  bool _isTime = false;

  @override
  Widget build(BuildContext context) {

   

    return _buildGameScaffold();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  void _listenShakes(){ _shakeCounter = 0;

    double _prevY = 1;
    bool _isRising = false;

    accelerometerEvents.listen((AccelerometerEvent event) {
      // print(event.y);
      if((event.y - _prevY).abs() > 0.2 && _isTime) {
        
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
    });}

  Scaffold _buildGameScaffold() {

    return new Scaffold(
      appBar: AppBar(title: Text("Timer test")),
      body: Center(
        child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          !_isTime ? RaisedButton(
            onPressed: () {
              _start = 10;
              startTimer();
              _listenShakes();
            },
            
            child: Text("Start"),
          ): Text("Shake it !"),
          Text("$_start")
        ],
      )));
  }

  Timer _timer;
  int _start =10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _isTime = true;
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
                _isTime = false;
              } else {
                _start = _start - 1;
              }
            }));
  }

}

