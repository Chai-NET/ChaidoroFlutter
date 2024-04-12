import 'dart:async';
import 'package:chaidoro20/Assets/SubTaskWidget.dart';
import 'package:chaidoro20/Assets/svgs.dart';
import 'package:flutter/material.dart';
import '../Models/task.dart';
import '../db/db_provider.dart';
import '../editing.dart';
import 'custom_widgets.dart';

class TaskWidget extends StatefulWidget {

  final MapEntry<Task,List<SubTask>> taskMap;
  const TaskWidget({
    required this.taskMap,
    super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> with TickerProviderStateMixin{

  double startPosition = 0;
  double swipeValue = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  // late List<Widget> _ widget.taskMap.value;
  @override
  void initState() {
    // TODO: implement initState
    // for( int i=0; i<taskMap.value.length;i++ ){
    //   _ widget.taskMap.value.add(SubtaskItem(i));
    // }
    _controller = AnimationController(duration: const Duration(milliseconds: 500),vsync: this);
    _controller.addListener(() {
      setState(() {
      });
    });

    _scaleAnimation = TweenSequence<double>(
        [
          TweenSequenceItem(tween: Tween(begin: 1,end: 1.01), weight: 1),
          TweenSequenceItem(tween: Tween(begin:1.015,end: 1.05), weight: 1)
          ]
    ).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (_){
        startPosition = _.localPosition.dx;
      },
      onHorizontalDragUpdate: (_){
        if(_.localPosition.dx-startPosition>0){
          swipeValue = _.localPosition.dx-startPosition;
          setState(() {
          });
        }
      },
      onHorizontalDragEnd: (_) {
        if(swipeValue > 50){
          EditController.instance.selectTaskController.add( widget.taskMap.key.id! );
          swipeValue=0;
          Navigator.pop(context);
        }
      },
      child: Transform.translate(
        offset: Offset(swipeValue, 0),
        child: Container(
          width: 100,
          padding: const EdgeInsets.only(top: 15,left: 20, right: 15,bottom: 15 ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: Colors.black, width: 1.5, ),
            color:  const Color.fromRGBO(247, 218, 210, 1)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        EditController.instance.editController.add(MapEntry(widget.taskMap.key.id!, -2));
                        // editTaskName(int widget.taskMap.key.id);
                        },
                      child: Text( widget.taskMap.key.title , style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w800,height: 1.0), )) ),
                  GestureDetector(
                      onTap: (){
                        EditController.instance.editController.add( MapEntry(widget.taskMap.key.id!,-1));
                      },
                      child: plusIcon(),
                  )
                ],
              ),
              if( widget.taskMap.value.isNotEmpty)
              SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics:const NeverScrollableScrollPhysics(),
                  itemCount:  widget.taskMap.value.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: SubTaskWidget(
                          taskId: widget.taskMap.key.id!,
                          subtaskId: widget.taskMap.value.elementAt(index).subtaskId!,
                          subtitle: widget.taskMap.value.elementAt(index).subtitle,
                          toggleOn: widget.taskMap.value.elementAt(index).toggleOn
                      ),
                    );
                  },
                  padding: const EdgeInsets.only(left: 5,top: 4,right: 0,bottom: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.clearListeners();
    _controller.dispose();
    super.dispose();
  }
}
