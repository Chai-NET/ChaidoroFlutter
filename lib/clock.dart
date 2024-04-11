import 'package:flutter/cupertino.dart';
import 'dart:async';

class Clock{
  List<Widget> taskList = <Widget>[];
  static final Clock _clockSingleton=Clock._internal();
  static int _defaultTime = 25;
  static int _defaultBreakTime=5;
  bool isBreak=false;
  Clock._internal();
  bool _clockState=false;
  final StreamController<bool> _changeController = StreamController<bool>.broadcast(
      onListen:(){},
      onCancel: (){},
      sync: false
  );
  final StreamController<bool> _controller = StreamController<bool>.broadcast(
      onListen: (){},
      onCancel: (){},
      sync: false
  );
  Stream<bool> get controller => _controller.stream;
  Stream<bool> get changeController => _changeController.stream;

  int get defaultTime => _defaultTime;
  int get defaultBreakTime => _defaultBreakTime;

  Duration _decreasingDuration=  Duration(minutes: _defaultTime);
  Duration _decreasingBreakDuration=  Duration(minutes: _defaultBreakTime);
  // Duration _increasingDuration = Duration( seconds: ProgressData.totalSecondsAtDate( DateTime.now() ) );

  Duration get decreasingDuration => _decreasingDuration;
  Duration get decreasingBreakDuration => _decreasingBreakDuration;

  // Duration get increasingDuration => _increasingDuration;
  // void setIncreasingDuration(Duration duration) => _increasingDuration = duration;
  void setDecreasingDuration(Duration duration) => _decreasingDuration = duration;
  void setDecreasingBreakDuration(Duration duration) => _decreasingBreakDuration = duration;


  void increaseByFive(){
    _decreasingDuration=Duration(seconds: decreasingDuration.inSeconds + 300);
    _changeController.add(_clockState);
  }
  void decreaseByFive(){
    if(_decreasingDuration.inSeconds<300) {
      _decreasingDuration=const Duration(seconds: 0);
      _clockState=false;} else{
      _decreasingDuration=Duration(seconds: _decreasingDuration.inSeconds - 300);
    }
    _changeController.add(_clockState);
  }
  static void setDefaultTime(int time){
    _defaultTime=time;
  }

  static void setDefaultBreakTime(int time){
    _defaultBreakTime=time;
  }
  String decreasingClockGetter(){
    if(_decreasingDuration.inHours>10){
      return _decreasingDuration.toString().substring(0,7) ;
    }else if(_decreasingDuration.inHours>0){
      return "0${_decreasingDuration.toString().substring(0,7)}" ;
    }else{
      return _decreasingDuration.toString().substring(2,7);
    }
  }
  // String increasingClockGetter(){
  //   if(_increasingDuration.inHours>10){
  //     return _increasingDuration.toString().substring(0,7);
  //   }else {
  //     return "0${_increasingDuration.toString().substring(0,7)}";
  //   }
  // }
  static Clock getInstance(){
    return _clockSingleton;
  }

  void clickClock(){
    if(_clockState){
      _clockState=false;
    }else{
      _clockState=true;
    }
    _controller.add(_clockState);
  }

  void stopClock(){
    _clockState=false;
    _controller.add(_clockState);
  }
  void changeCycle(){
    if(isBreak){
      _decreasingDuration=Duration(minutes: _defaultTime);
    }else{
      _decreasingDuration=Duration(minutes: _defaultBreakTime);
    }
    isBreak=!isBreak;
    clickClock();
  }
  bool clockStateCheck(){
    return _clockState;
  }
}
