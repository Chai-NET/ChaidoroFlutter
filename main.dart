// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'TimerPage.dart';
void main() {
  runApp( TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:TimerPage(),
    );
  }
}