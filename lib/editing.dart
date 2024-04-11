import 'dart:async';

import 'package:chaidoro20/db/db_provider.dart';

import 'Models/task.dart';

class EditController {
  EditController._();
  static final EditController instance = EditController._();

  Task lastTask = Task( id: 0, title :"What do you want to work on today? ฅ^•ﻌ•^ฅ",dateCreated: DateTime.now(),seconds: 0);


  final StreamController<int> selectTaskController = StreamController<int>.broadcast();
  Stream<Task> onTaskSelect() {
    late StreamController<Task> ctlr ;
    StreamSubscription? triggerSubscription ;
    Future<void> sendUpdate(int _) async {
      if (!ctlr.isClosed) {
        lastTask =  await DbProvider.instance.queryTaskAlone(_);
      }
    }
    ctlr = StreamController<Task>(
        onListen: () {
          /// Listen for trigger
          triggerSubscription = selectTaskController.stream.listen((_) {
            sendUpdate(_);
          });
        },
        onCancel: () {
          triggerSubscription?.cancel();
        }
    );
    return ctlr.stream;
  }


  final StreamController<MapEntry<int,int>> editController = StreamController.broadcast();
  Stream<MapEntry<int,int>> get editTaskStream => editController.stream;

  // addSubtask [ n : -1 ]
  // addTask [ -1 : -1 ]
  // selectSubtask [ n : m ]
  // selectTask [ n : -2 ]

}