import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors/sensors.dart';

class Game extends StatefulWidget {
  @override
  _FlutterGameState createState() => _FlutterGameState();
}

class _FlutterGameState extends State<Game>
    with SingleTickerProviderStateMixin {

  static const String FIREBASE_KEY = 'score';

  static int onlineBestScore;

  bool _img1 = false;
  bool _img2 = false;
  int _shakeCounter;
  bool hide = false;
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

  void _listenShakes() {
    _shakeCounter = 0;

    double _prevY = 1;
    bool _isRising = false;

    accelerometerEvents.listen((AccelerometerEvent event) {
      // print(event.y);
      if ((event.y - _prevY).abs() > 0.2 && _isTime) {
        if (event.y > _prevY) {
          // it's going up
          if (!_isRising) {
            _shakeCounter++;
          }
          _img1 = true;
          _img2 = false;
          _isRising = true;
        } else if (event.y < _prevY) {
          // i's going down
          if (_isRising) {
            _shakeCounter++;
          }
          _img1 = false;
          _img2 = true;
          _isRising = false;
        }

        _prevY = event.y;

        print(_shakeCounter);
      }
    });
  }


  Scaffold _buildGameScaffold() {
    FirebaseAuth.instance.currentUser().then( (user) async {
      if (user == null) {
        // local persist
        // _localPersist(score);
      } else {
        _firebaseListen(user);
      }
    });

    return new Scaffold(
        appBar: AppBar(
          title: Image(
            image: AssetImage(
              "images/fuckthis.png",
            ),
            height: 100.0,
            fit: BoxFit.fitHeight,
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: !_isTime
                  ? FlatButton(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        _start = 10;
                        startTimer();
                        _listenShakes();
                      },
                      child: 
                        Text(_shakeCounter != null ? "Try again ?" : "Start",
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        )),
                    )
                  : Text(
                      "Shake it !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18),
              child: _shakeCounter != null ? Text("Score:") : Text(""),
            ),
            _shakeCounter != null
                ? Text(
                    "$_shakeCounter",
                    style: TextStyle(
                      fontSize: 104.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.pinkAccent,
                    ),
                  )
                : Text(""),
            Container(
              child: Visibility(
                visible: _isTime,
                child: Text("$_start secondes restantes"),
              ),
            ),
            Container(
                child: Visibility(
              visible: _img1,
              child: Image(
                  image: AssetImage("images/shakelefttop.png"),
                  height: 450.0,
                  fit: BoxFit.fitHeight),
            )),
            Container(
                child: Visibility(
              visible: _img2,
              child: Image(
                  image: AssetImage("images/shakeleftbottom.png"),
                  height: 450.0,
                  fit: BoxFit.fitHeight),
            )),
            Container(
              child: Visibility(
                visible: !_isTime,
                child: Text("Best score: $onlineBestScore"),
              ),
            ),
          ],
        )));
  }

  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _isTime = true;
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
                _isTime = false;
                _img1 = false;
                _img2 = false;
                _persistScore(_shakeCounter); // DEBUG
              } else {
                _start = _start - 1;
              }
            }));
  }

  void _persistScore(int score) {
    FirebaseAuth.instance.currentUser().then( (user) async {
      if (user == null) {
        // local persist
        // _localPersist(score);
      } else {
        // firebase persist
        await _firebasePersist(score, user);
        _firebaseListen(user);
      }
    });
  }

  Future<void> _firebasePersist(int score, FirebaseUser user) async {
    if(score > onlineBestScore) {
     return FirebaseDatabase.instance
        .reference()
        .child("users")
        .child( user.uid.toString())
        .child(FIREBASE_KEY)
        .set(score);
    }
  }

  void _firebaseListen(FirebaseUser user) {
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child( user.uid.toString())
        .child(FIREBASE_KEY)
        .onValue
        .listen( (Event event) {
          onlineBestScore = event.snapshot.value;
        });
  }

}
