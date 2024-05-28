import 'dart:math';
import 'Components/Calendar.dart';
import 'package:chaidoro20/screen_dimension.dart';
import 'package:chaidoro20/Providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Assets/custom_widgets.dart';
import 'Assets/svgs.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String totalWork ="00:00";
  String totalWorkToday = "00:00";
  double _swipeUp = 0;
  double _startPosition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DbProvider.instance.dailyTotalSeconds(DateTime.now()).then((value){
      totalWorkToday = Calendar.secondsFormatter( value );
      setState(() {});
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 218, 210, 1),
      body: Container(
        width: 100.vw(context),
        height: 100.vh(context),
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 30),
                        width: double.maxFinite,
                        child: const FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Calendar()
                        )
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children:[
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: 300,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: double.maxFinite,
                                          height: 35,
                                          color: Colors.black12,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            color: Colors.black12,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                Calendar.numericDateTimeFormatter(DateTime.now()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          height: 15,
                                          color: Colors.black38,
                                        ),
                                        Expanded(
                                            child: Container(
                                              color: Colors.black12,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                color: Colors.black12,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    //getThisWeekWorkFromDB()
                                                    totalWork,
                                                    style: TextStyle(color: Colors.black38),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          height: 15,
                                          color: Colors.black38,
                                        ),
                                        Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              color: Colors.black12,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  totalWorkToday,
                                                  style: TextStyle(color: Colors.black38),
                                                  //progressThisDay()
                                                ),
                                              ),
                                            )
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          height: 15,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 300,
                                    child: Container(
                                      color: Colors.brown.shade700,
                                      margin:const EdgeInsets.all(15),
                                      //child: RankPng()
                                    ),
                                  )
                                ),

                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                            ),
                          )
                        ],

                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: 100.vw(context),
                  padding: const EdgeInsets.symmetric(horizontal: 30 ),
                  color: const Color.fromRGBO(247, 218, 210, 1),
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onVerticalDragStart: (values){
                       _startPosition = values.globalPosition.dy;
                    },
                    onVerticalDragUpdate: (values){
                      if(_startPosition > values.globalPosition.dy ){
                        _swipeUp = _startPosition - values.globalPosition.dy;
                        setState(() {});
                        if(_swipeUp >250){
                          Navigator.pop(context);
                        }
                      }
                    },
                    onVerticalDragEnd: (_){
                      if(_swipeUp>150&&_swipeUp<250){
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 17.vw(context),
                      margin: EdgeInsets.only(bottom: _swipeUp),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.only(right: 15),
                              height: 3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(127,95,83,1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Transform.flip(
                              flipY: true,
                              child: Container(
                                padding: const EdgeInsets.only(top: 16),
                                child: CustomPaint(
                                  size: const Size(32, 48),
                                  painter: DragDownPainter(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:const EdgeInsets.only(left: 15),
                              height: 3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(127,95,83,1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
