import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chaidoro20/Assets/task_widget.dart';
import 'package:chaidoro20/Models/task.dart';

import 'Providers/db_provider.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({
    super.key
  });

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {

  late Stream<Map<Task, List<SubTask>>> _stream ;

  @override
  void initState() {
    // TODO: implement initState

    _stream = DbProvider.instance.onTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: ( context, AsyncSnapshot<Map<Task, List<SubTask>>> snapshot ){
        if(snapshot.hasData){
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll){
              overscroll.disallowIndicator();
              return false;
            },
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TaskWidget(taskMap: snapshot.data!.entries.elementAt(index)),
                );
              },
              padding: const EdgeInsets.all(5),
            ),
          );
        }else{
          return const Text("Ready to start on your first task?", textAlign: TextAlign.center, style: TextStyle(fontSize: 23,fontWeight: FontWeight.w800),);
        }
      }
  );
  }
}


