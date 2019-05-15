import 'dart:async';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:sensors/sensors.dart';

/// @link https://stackoverflow.com/a/51802274
class SensorBloc {

  StreamSubscription<dynamic> _accelerometerStream;

  //INPUT
  final _thresholdController = StreamController<int>();
  Sink<int> get threshold => _thresholdController.sink;


  // OUTPUT
  final  _shakeDetector = StreamController<bool>();
  Stream<bool> get shakeEvent => _shakeDetector.stream.transform(ThrottleStreamTransformer((_) => TimerStream(true, const Duration(seconds: 2))));


  SensorBloc() {
    const CircularBufferSize = 10;
    double detectionThreshold = 70.0;

    List<double> circularBuffer = List.filled(CircularBufferSize,0.0);
    int index = 0;
    double minX=0.0, maxX=0.0;

    _thresholdController.stream.listen((value){
      // safety
      if (value > 30) detectionThreshold = value*1.0;
    });

    _accelerometerStream =  accelerometerEvents.listen((AccelerometerEvent event){
        index = (index == CircularBufferSize -1 ) ? 0: index+1;

        var oldX = circularBuffer[index];

        if (oldX == maxX) {
          maxX = circularBuffer.reduce(max);
        }
        if (oldX == minX) {
          minX = circularBuffer.reduce(min);
        }

        circularBuffer[index] = event.x;
        if (event.x < minX ) minX=event.x;
        if (event.x> maxX) maxX = event.x;

        if (maxX-minX>detectionThreshold)
        {
          _shakeDetector.add(true);
          circularBuffer.fillRange(0, CircularBufferSize, 0.0);
          minX=0.0;
          maxX=0.0;
        }


    });

  }



  void dispose() {
    _shakeDetector.close();
    _accelerometerStream.cancel();
   _thresholdController.close();
  }
}