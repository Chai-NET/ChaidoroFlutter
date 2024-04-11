import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();


}

class _TimerPageState extends State<TimerPage> {


  bool clockState=false;

  Timer? timer;

  Duration decreasingDuration= Duration(minutes: 25);

  Duration increasingDuration= Duration(seconds: 0);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).viewPadding;

    double height1 = height - padding.top - padding.bottom;

    // total flex index 76


    return Scaffold(

      backgroundColor: Color.fromRGBO(255, 207, 193,1),

      body: Column(

        children: <Widget>[

          Expanded(flex:2,child: Container(

          )),
          Expanded(flex:5,child: Container(

            alignment: Alignment.bottomCenter,

            child: Container(

              width: 140,

              height: double.maxFinite,

              alignment: Alignment.center,

              decoration: BoxDecoration(

                color: Color.fromRGBO(129, 95, 80,1),

                borderRadius: BorderRadius.circular(15),

              ),

                child: Text("${clockFormat(increasingDuration.inHours.remainder(60))}:${clockFormat(increasingDuration.inMinutes.remainder(60))}:${clockFormat(increasingDuration.inSeconds.remainder(60))}",
                  style: TextStyle(
                  fontSize: 24,
                  color: Color.fromRGBO(255, 207, 193,1),
                ),
            ),



            ),

          )),
          Expanded(
            flex: 5,
            child: Container(
            ),
          ),
          Expanded(flex:41,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Positioned(
                    top:0,
                        child: InkWell(
                          onTap: (){

                            setState(() {

                              decreasingDuration=Duration(seconds:decreasingDuration.inSeconds+300);
                            });
                          },
                          child: Icon(


                            Icons.keyboard_arrow_up_rounded,

                            size:  height1*23/76,

                            color: Color.fromRGBO(129, 95, 80,1),


                          ),
                        )

                  ),
                  Positioned(

                    top: height1*(20.5)/76,

                      child:InkWell(
                        onTap: (){
                          setState(() {

                            decreasingDuration=Duration(seconds:decreasingDuration.inSeconds-300);
                          });
                        },
                        child: Icon(


                          Icons.keyboard_arrow_down_rounded,

                          size:  height1*23/76,

                          color: Color.fromRGBO(129, 95, 80,1),


                        ),
                      )


                  ),
                  Positioned(

                    top:height1*(15)/76 ,

                    child: TextButton(
                      onPressed: (){
                        decreasingClockStart();
                      },
                      child: Text(
                        "${clockFormat(decreasingDuration.inMinutes.remainder(60))}:${clockFormat(decreasingDuration.inSeconds.remainder(60))}",
                      ),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(

                          fontSize: height1*11/76,

                          color:Color.fromRGBO(129, 95, 80,1),),
                        foregroundColor: Color.fromRGBO(129, 95, 80,1),
                      ),
                    ),

                  )

                ],

              )

    ), //stack

          Expanded(flex:11,child: Container(

          )),
          Expanded (flex: 12,
            child: Padding (

                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                ),

                child: Container(

                  decoration: BoxDecoration(

                      color: Color.fromRGBO(129, 95, 80,1),

                      borderRadius: BorderRadius.only(

                        topRight: Radius.circular(14),

                        topLeft: Radius.circular(14),
                      )

                  ),
                )),

          ),

        ],

      ),

    );

  }
  void decreasingClockStart(){

    if(clockState){
      clockState=false;
    }else{
      clockState=true;
    }
    if(clockState){
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1),(timer){
        int timeFlies = 1 ;
        setState(() {
          int currentIncreasingTime=increasingDuration.inSeconds+timeFlies;
          int currentDecreasingTime=decreasingDuration.inSeconds-timeFlies;
          decreasingDuration= Duration(seconds: currentDecreasingTime);
          increasingDuration= Duration(seconds: currentIncreasingTime);
        });
      });

    });}else{
      timer!.cancel();
    }
  }

  String clockFormat( int a) { return a.toString().padLeft( 2 , "0" ) ; }



}

//rgba(153,126,119,1) blue
//rgba(255, 207, 193,1) white
//rgba(153,126,119,1) dark brown
//rgba(188, 130, 104,1) light brown
//ratios b to t 12 14 35 8 5 2
