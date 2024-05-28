import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:chaidoro20/Models/progess_instance.dart';
import 'package:chaidoro20/screen_dimension.dart';
import 'package:chaidoro20/Providers/db_provider.dart';
import 'package:chaidoro20/editing.dart';
import 'package:flutter/material.dart';
import 'package:chaidoro20/Assets/svgs.dart';
import 'package:chaidoro20/Assets/custom_widgets.dart';
import 'Models/task.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin{
  // vars for clock
  bool _isWorkTime = true;
  bool _clockIsOn = false;

  final Duration _workDuration = const Duration(minutes:25);
  final Duration _breakDuration = const Duration(minutes:5);

  Duration _timerDuration =  const Duration(minutes:25);
  Timer? _timer;
  late Stream<Task> _taskUpdateStream ;

  late AnimationController _controller ;

  //vars for reset animation
  Timer? _scaleTimer;
  late Animation<double> _spinAnimation ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskUpdateStream = EditController.instance.onTaskSelect();
    _taskUpdateStream.listen((event) async {
      print( EditController.instance.lastTask.title);
      print("set fr");
      setState(() {});
      if(_timer!=null){
        if(_timer!.isActive){
          await DbProvider.instance.insertProgressInstance(ProgressInstance(dateUpdated: DateTime.now(), taskId: EditController.instance.lastTask.id! , seconds: _timer!.tick));
          await DbProvider.instance.updateTaskTime(EditController.instance.lastTask.id ?? 0, _timer!.tick);
        }
      }
    });
    _controller = AnimationController(duration: const Duration(milliseconds: 1000),vsync: this);
    _controller.addListener(() {
      setState(() {
      });
    });
    _spinAnimation = Tween<double>(begin: 0, end: pi/2).chain(CurveTween(curve: Curves.easeInOutQuart)).animate(_controller);
  }
  double _bottomInset = 0;

  double _screenOffset = 0;
  double _slide = 0;
  bool _settingsOn = false;
  double _dragDownVariable = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          child: SizedBox(
            width: 100.vw(context),
            height: 100.vh(context)-1.getPadding(context).bottom-1.getPadding(context).top,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                    left: 10,
                    child: Container(
                        margin: const EdgeInsets.only(bottom:100),
                        child: ArrowLeft())
                ),
                Positioned(
                    right: 10,
                    child: Container(
                        margin: const EdgeInsets.only(bottom:100),
                        child: ArrowRight())
                ),
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragDown: (details){
                      _screenOffset = details.globalPosition.dx;
                    },
                    onHorizontalDragUpdate: (values){
                      if(_settingsOn){
                        _slide = values.globalPosition.dx - _screenOffset + 72.vw(context);
                        if(_slide - 72.vw(context)<0){
                          setState(() {});
                        }
                      }else{
                        _slide = values.globalPosition.dx - _screenOffset;
                        if(_slide>0){
                          setState(() {});
                        }
                        if(_slide < - 170){
                          Navigator.pushNamed(context, 'tasks');
                        }
                      }
                    },
                    onHorizontalDragEnd: (details){
                      if(_settingsOn){
                        if(_slide - 72.vw(context) <-80){
                          _settingsOn = false;
                          _slide =0;
                          setState(() {});
                        }else {
                          _slide = 72.vw(context);
                          setState(() {});
                        }
                      }else{
                        if(_slide > 170){
                          _settingsOn = true;
                          _slide = 72.vw(context);
                          setState(() {});
                        }else {
                          _slide = 0;
                          setState(() {});
                        }
                      }
                    },
                    child: SizedBox(
                      width: 100.vw(context),
                      height: 100.vh(context) - 160 ,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100.vw(context) + 40,
                  height: 100.vw(context) + 140,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if(_clockIsOn){
                      _clockIsOn = false;
                      if(_isWorkTime&&EditController.instance.lastTask.id!=null){
                        await DbProvider.instance.insertProgressInstance(ProgressInstance(dateUpdated: DateTime.now(), taskId: EditController.instance.lastTask.id! , seconds: _timer!.tick));
                        await DbProvider.instance.updateTaskTime(EditController.instance.lastTask.id ?? 0, _timer!.tick);
                      }
                      _timer?.cancel();
                    }
                    else{
                      _clockIsOn = true;
                      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                        if(_timerDuration.inSeconds!=0){
                          _timerDuration = Duration(seconds: _timerDuration.inSeconds - 1) ;
                        }else{
                          if(_isWorkTime){
                            _isWorkTime = false;
                            _timerDuration = _breakDuration;
                          }else{
                            _isWorkTime = true ;
                            _timerDuration = _workDuration;
                          }
                        }
                        setState(() {});
                      });
                    }
                  },
                  onVerticalDragStart: (details){
                    _bottomInset = details.globalPosition.dy;
                  },
                  onVerticalDragUpdate: (details){
                    if(_timer!=null){
                      if(_isWorkTime){
                        _controller.value = ((_bottomInset - details.globalPosition.dy)/(100.vw(context) + 40)<0)? -(_bottomInset - details.globalPosition.dy)/(100.vw(context) + 40) :  (_bottomInset - details.globalPosition.dy)/(100.vw(context) + 40) ;
                      }else{
                        _controller.value = 1 - (((_bottomInset - details.globalPosition.dy)/(100.vw(context) + 40)<0)? -(_bottomInset - details.globalPosition.dy)/(100.vw(context) + 40) :  (_bottomInset - details.globalPosition.dy)/(100.vw(context) + 40)) ;
                      }
                    }
                    },
                  onVerticalDragEnd: (details) async {
                      if(_isWorkTime){
                        if(_controller.value>0.5){
                          if(EditController.instance.lastTask.id!=null){
                            await DbProvider.instance.insertProgressInstance(ProgressInstance(dateUpdated: DateTime.now(), taskId: EditController.instance.lastTask.id! , seconds: _timer!.tick));
                            await DbProvider.instance.updateTaskTime(EditController.instance.lastTask.id ?? 0, _timer!.tick);
                          }
                          _isWorkTime = false;
                          _timerDuration = const Duration(minutes: 5);
                          _timer?.cancel();
                          _controller.forward(from:_controller.value);
                        }
                        else{
                          _controller.reverse(from:_controller.value);
                        }
                      }
                      else{
                        if(_controller.value<0.5){
                          _isWorkTime = true ;
                          _timerDuration = const Duration( minutes: 25 );
                          _timer?.cancel();
                          _controller.reverse(from: _controller.value);
                        }
                        else{
                          _controller.forward(from: _controller.value);
                        }
                      }
                      _bottomInset = 0;
                      _clockIsOn = false;
                      setState(() {});

                  },
                  onHorizontalDragDown: (details){
                    _screenOffset = details.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (values){
                    if(_settingsOn){
                      _slide = values.globalPosition.dx - _screenOffset + 72.vw(context);
                      if(_slide - 72.vw(context)<0){
                        setState(() {});
                      }
                    }else{
                      _slide = values.globalPosition.dx - _screenOffset;
                      if(_slide>0){
                        setState(() {});
                      }
                      if(_slide < - 170){
                        Navigator.pushNamed(context, 'tasks');
                      }
                    }
                  },
                  onHorizontalDragEnd: (details){
                    if(_settingsOn){
                      if(_slide - 72.vw(context) <-80){
                        _settingsOn = false;
                        _slide =0;
                        setState(() {});
                      }else {
                        _slide = 72.vw(context);
                        setState(() {});
                      }
                    }else{
                      if(_slide > 170){
                        _settingsOn = true;
                        _slide = 72.vw(context);
                        setState(() {});
                      }else {
                        _slide = 0;
                        setState(() {});
                      }
                    }
                  },
                  child: SizedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100.vw(context) + 40,
                          height: 100.vw(context) + 140,
                        ),
                        Container(
                          margin: const  EdgeInsets.only(bottom: 100),
                          width: 100.vw(context) - 60,
                          height: 100.vw(context) - 60,
                          padding: const EdgeInsets.all(50),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:const  EdgeInsets.symmetric(horizontal: 15),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Transform(
                                      alignment: Alignment.topCenter,
                                      transform: Matrix4.rotationX(_spinAnimation.value),
                                      child: Container(
                                          color:  const Color.fromRGBO(247, 218, 210, 1),
                                          child: Text(_getWorkTimerMinuteString(), style: const TextStyle(fontWeight: FontWeight.w800),)),
                                    )),
                                )),
                              Expanded(
                                child: Padding(
                                  padding:const  EdgeInsets.symmetric(horizontal: 15),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Transform(
                                      alignment: Alignment.topCenter,
                                      transform: Matrix4.rotationX(_spinAnimation.value),
                                      child: Container(
                                        color:  const Color.fromRGBO(247, 218, 210, 1),
                                        child: Text(
                                            _getWorkTimerSecondString(),style: const TextStyle(fontWeight: FontWeight.w400,)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        Container(
                            margin: const  EdgeInsets.only(bottom: 100),
                            width: 100.vw(context) - 60,
                            height: 100.vw(context) - 60,
                            padding: const EdgeInsets.all(50),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: Padding(
                                      padding:const  EdgeInsets.symmetric(horizontal: 15),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Transform(
                                            alignment: Alignment.topCenter,
                                            transform: Matrix4.rotationX((pi/2-_spinAnimation.value)),
                                            child: Container(
                                                color:  const Color.fromRGBO(247, 218, 210, 1),
                                                child: Text(_getBreakTimerMinuteString(), style: const TextStyle(fontWeight: FontWeight.w800),)),
                                          )),
                                    )),
                                Expanded(
                                  child: Padding(
                                    padding:const  EdgeInsets.symmetric(horizontal: 15),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Transform(
                                        alignment: Alignment.topCenter,
                                        transform: Matrix4.rotationX((pi/2-_spinAnimation.value)),
                                        child: Container(
                                          color:  const Color.fromRGBO(247, 218, 210, 1),
                                          child: Text(
                                              _getBreakTimerSecondString(),
                                              style: const TextStyle(fontWeight: FontWeight.w400,)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    child: Container(
                      width: 100.vw(context),
                      height: _dragDownVariable + 17.vw(context) + 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(247, 218, 210, 1),
                      ),
                    ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: 100.vw(context),
                    height: 100.vh(context)-1.getPadding(context).bottom-1.getPadding(context).top,
                    padding: EdgeInsets.only(top: _dragDownVariable, left: 30, right:30 ),
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onVerticalDragUpdate: (values) {
                        double padding =1.getPadding(context).top;
                        if( values.localPosition.dy >= padding){
                          _dragDownVariable = values.localPosition.dy - padding ;
                          setState(() {});
                        }
                      },
                      onVerticalDragEnd: (values){
                        if(_dragDownVariable > 35.vh(context)){
                          _dragDownVariable = 0;
                          Navigator.pushNamed(context, 'stats');
                          setState(() {});
                        }else{
                          _dragDownVariable = 0;
                          setState(() {});
                        }
                      },
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 17.vw(context),
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
                              child: Container(
                                padding: const EdgeInsets.only(top: 16),
                                child: CustomPaint(
                                  size: const Size(32, 48),
                                  painter: DragDownPainter(),
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
                  ),
                ),
                Positioned(
                    bottom: 25,
                    child: GestureDetector(
                      onTap:() => Navigator.pushNamed(context, 'tasks'),
                      child: Container(
                        width: 80.vw(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black)
                        ),
                        alignment: Alignment.center,
                        child: CustomListTile(
                          padding: const EdgeInsets.all( 20 ),
                          leading: const SizedBox( width: 10, ),
                          title: Text( EditController.instance.lastTask.title,style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 19,height: 1.0), ),
                          subtitle: const Text( "Goodluck!", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 1.0), ),
                          trailing: SizedBox(
                              height: 20,
                              child: ArrowRight()
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 100.vw(context) - _slide ,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragDown: (details){
              _screenOffset = details.globalPosition.dx;
            },
            onHorizontalDragUpdate: (values){
              if(_settingsOn){
                _slide = values.globalPosition.dx - _screenOffset + 72.vw(context);
                if(_slide - 72.vw(context)<0){
                  setState(() {});
                }
              }else{
                _slide = values.globalPosition.dx - _screenOffset;
                if(_slide>0){
                  setState(() {});
                }
                if(_slide < - 170){
                  Navigator.pushNamed(context, 'tasks');
                }
              }
            },
            onHorizontalDragEnd: (details){
              if(_settingsOn){
                if(_slide - 72.vw(context) <-80){
                  _settingsOn = false;
                  _slide =0;
                  setState(() {});
                }else {
                  _slide = 72.vw(context);
                  setState(() {});
                }
              }else{
                if(_slide > 170){
                  _settingsOn = true;
                  _slide = 72.vw(context);
                  setState(() {});
                }else {
                  _slide = 0;
                  setState(() {});
                }
              }
            },
            child: SizedBox(
                width: 72.vw(context),
                height: 100.svh(context),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right:15,top: 7,bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade600,
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 12.svh(context),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: 100,
                              height: 53,
                              color: Colors.brown.shade300,
                              child: Stack(
                                children: [
                                  const SizedBox(
                                    width:100,
                                    height: 13,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                          "13.12.23"
                                        //DateNow
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 53,
                                    width: 100,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                          "${DateTime.now().hour}:${DateTime.now().minute}"
                                        //TimeNow()
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: Colors.brown.shade300,
                              ),
                              // child: Pomotimer(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: Colors.brown.shade200,
                              ),
                              // child: Stats(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: Colors.brown.shade200,
                              ),
                              // child: Tasks(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: Colors.brown.shade200,
                              ),
                              // child: Settings(),

                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: Colors.brown.shade200,
                              ),
                              // child: Friends(),

                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: Colors.brown.shade200,
                              ),
                              // child: Notes(),

                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 43,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              width: 134,
                              height: 42,
                              decoration: BoxDecoration(
                                  color: Colors.brown.shade100,
                                  borderRadius: const BorderRadius.all(Radius.circular(5))
                              ),
                              // child: Profile(),

                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 25,bottom:28),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Container(
                                width:35,
                                height:35,
                                color: Colors.brown.shade200,
                                // child: Icon(),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                )
            ),
          ),
        ),
      ],
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }
  String _getWorkTimerMinuteString(){
    if(!_isWorkTime) {
      return "${_workDuration.inMinutes}";
    }else{
      return (_timerDuration.inMinutes<10)? "0${_timerDuration.inMinutes}": "${_timerDuration.inMinutes}";
    }
  }
  String _getWorkTimerSecondString(){
    if(!_isWorkTime) {
      return "00";
    }else{
      return (_timerDuration.inSeconds%60<10) ? "0${_timerDuration.inSeconds%60}" : "${_timerDuration.inSeconds%60}";
    }
  }
  String _getBreakTimerMinuteString(){
    if(_isWorkTime){
      return (_breakDuration.inMinutes<10)? "0${_breakDuration.inMinutes}": "${_breakDuration.inMinutes}";
    }else{
      return (_timerDuration.inMinutes<10)? "0${_timerDuration.inMinutes}": "${_timerDuration.inMinutes}";
    }
  }

  String _getBreakTimerSecondString(){
    if(_isWorkTime){
      return "00";
    }else{
      return (_timerDuration.inSeconds%60<10) ? "0${_timerDuration.inSeconds%60}" : "${_timerDuration.inSeconds%60}";
    }
  }

}



