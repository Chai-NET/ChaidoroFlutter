import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/task.dart';
import '../Models/progess_instance.dart';

class DbProvider {

  static const _dbName = 'task_database.db';
  static const _taskTable = "tasks";
  static const _progressInstanceTable = 'progress_instance';
  static const _subtaskTable = "sub_tasks"; 
  static const _dbVersion = 1;
  DbProvider._();

  final StreamController<bool>? listUpdateController = StreamController<bool>.broadcast(
    onListen: () async { }
  );
  Stream<bool>? get listUpdateStream => listUpdateController?.stream ;

  static final DbProvider instance= DbProvider._();

  Database? _db;

  Future<Database?> get db async => _db ??= await initializeDb();

  final _updateController = StreamController<bool>.broadcast();

  Stream<bool> get updateController => _updateController.stream;


  Future<Database?> initializeDb() async {
      _db =  await openDatabase(
        join( await getDatabasesPath(), _dbName ),
        onCreate: _onCreate,
        version: _dbVersion,
      );
      return _db;
  }
  Stream<Map<Task, List<SubTask>>> onTask() {
    late StreamController<Map<Task, List<SubTask>>> ctlr;
    StreamSubscription? triggerSubscription;
    Future<void> sendUpdate() async {
      var tasksList = await tasks();
      if (!ctlr.isClosed) {
        ctlr.add(tasksList);
        print("to be built");
      }
    }
    ctlr = StreamController<Map<Task, List<SubTask>>>(
      onListen: () {
        sendUpdate();
      /// Listen for trigger
        triggerSubscription = _updateController.stream.listen((_) {
          sendUpdate();
          print("sent");
        });
      },
      onCancel: () {
        triggerSubscription?.cancel();
      }
    );
    return ctlr.stream;
  }



  Future _onCreate(Database db, int version) async{
    try {
      const createTasksQuery =
          'CREATE TABLE IF NOT EXISTS $_taskTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, seconds INTEGER NOT NULL, date_created TEXT NOT NULL, date_updated TEXT NOT NULL, CONSTRAINT title_unique UNIQUE (title) )';
      const createSubTasksQuery =
          'CREATE TABLE IF NOT EXISTS $_subtaskTable (sub_task_id INTEGER PRIMARY KEY AUTOINCREMENT, task_id INTEGER NOT NULL, sub_title TEXT NOT NULL, bool INTEGER, CONSTRAINT sub_title_unique UNIQUE (sub_title, task_id) )';
      const createSpecificProgressQuery =
          'CREATE TABLE IF NOT EXISTS $_progressInstanceTable ( date_updated TEXT NOT NULL, task_id INTEGER NOT NULL, seconds INTEGER NOT NULL )';
      await db.execute(createTasksQuery);
      await db.execute(createSubTasksQuery);
      await db.execute(createSpecificProgressQuery);
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> insertTask(Task task) async {
    _db ??= await initializeDb();
    await _db?.insert(
      _taskTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
    _updateController.add(true);
  }

  Future<void> insertSubTask(SubTask subTask) async {
    _db ??= await initializeDb();
    await _db?.insert(
      _subtaskTable,
      subTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
    _updateController.add(true);
  }
  Future<void>  updateSubtask(int subtaskId, int? bool, String? subTitle) async {
    _db ??= await initializeDb();
    if(subTitle==""){
      _db?.rawUpdate("UPDATE $_subtaskTable SET bool = ? WHERE sub_task_id = ?",[bool, subtaskId] );
    }else{
      _db?.rawUpdate("UPDATE $_subtaskTable SET sub_title = ? WHERE sub_task_id = ?",[subTitle, subtaskId] );
    }
    _updateController.add(true);
  }

  Future<void>  updateTaskTitle( int taskId, String title ) async {
    _db ??= await initializeDb();
      _db?.rawUpdate("UPDATE $_taskTable SET title = ? WHERE id = ?",[title,taskId]);
      _updateController.add(true);
  }

  Future<void>  updateTaskTime( int taskId, int seconds ) async {
    _db ??= await initializeDb();
    int currentSeconds = (await instance.queryTaskAlone(taskId)).seconds;
    await _db?.rawUpdate("UPDATE $_taskTable SET seconds = ? WHERE id = ?",[currentSeconds + seconds,taskId]);
    await _db?.rawUpdate("UPDATE $_taskTable SET date_updated = ? WHERE id = ?",[ DateTime.now().toIso8601String(),taskId]);
    _updateController.add(true);
  }
  
  Future<void> deleteSubTask(int subtaskId) async {
    _db ??= await initializeDb();
    await _db?.rawDelete("DELETE from $_subtaskTable WHERE sub_task_id = $subtaskId");
    _updateController.add(true);
    print("updated");
  }
  Future<void> deleteTask(int id) async {
    _db ??= await initializeDb();
    await _db?.rawDelete("DELETE from $_taskTable WHERE id = $id");
    _updateController.add(true);

  }


  Future<Task> queryTaskAlone(int id) async {
    Task task ;
    _db ??= await initializeDb();
    List<Map<String, Object?>>? list = await _db?.rawQuery('SELECT * FROM $_taskTable WHERE id=?', ["$id"]);

   (list!.isNotEmpty)? task = Task.fromSqliteDoc(list.first) : task = Task(id:0,title: "",dateCreated: DateTime.now(), seconds: 0);
    return task;

  }
  Future<MapEntry<Task, List<SubTask>>> queryTaskId(int id) async {
    _db ??= await initializeDb();
    Task task;
    List<Map<String, Object?>>? list = await _db?.rawQuery('SELECT * FROM $_taskTable WHERE id=?', ["$id"]);
    if(list!.isEmpty){
      task = Task(id:0 ,title: "error", dateCreated: DateTime.now(),seconds: 0);
    }else{
      task = Task.fromSqliteDoc(list.first);
    }
    List<SubTask> subtaskList = [];
    List<Map<String, Object?>>? subtaskMaps = await _db?.rawQuery('SELECT * FROM $_subtaskTable WHERE task_id=?', ["$id"]);
    if(subtaskMaps!.isNotEmpty){
      for (var element in subtaskMaps) {
        subtaskList.add(SubTask.fromSqliteDoc(element));
      }
    }
    MapEntry<Task, List<SubTask>> finalMapEntry = <Task, List<SubTask>>{task : subtaskList}.entries.first;
    return finalMapEntry;
  }

  Future<List<Task>> tasksByDate(DateTime date) async {
    _db ??= await initializeDb();
    final List<Map<String, Object?>>? tasksMap = await _db?.rawQuery('SELECT * FROM tasks WHERE date_updated=?', [date.toIso8601String()]);
    List<Task> finalList = [];
    tasksMap?.forEach((element) {
      Task cursor = Task.fromSqliteDoc(element);
      finalList.add(cursor);
    });
    return finalList;
  }

  Future<Map<Task, List<SubTask>>> tasks() async {
    _db ??= await initializeDb();
    final  List<Map<String, Object?>>? taskMaps = await _db?.rawQuery('SELECT * FROM tasks');
    final  List<Map<String, Object?>>? subtaskMaps = await _db?.rawQuery('SELECT * FROM sub_tasks');
    Map<Task,List<SubTask>> finalMap = {};

    taskMaps?.forEach((element) {
      Task cursor = Task.fromSqliteDoc(element);
      List<SubTask> cursorList = [];
      subtaskMaps?.forEach((element) {
        SubTask subCursor = SubTask.fromSqliteDoc(element);
        if(cursor.id == subCursor.taskId){
          cursorList.add(subCursor);
        }
      });
      finalMap.addAll(<Task, List<SubTask>>{cursor : cursorList});
    });
    return finalMap;
  }

  Future<void> insertProgressInstance(ProgressInstance progressInstance) async {
    _db ??= await initializeDb();
    _db?.insert(_progressInstanceTable, progressInstance.toMap());
  }
  Future<List<Map<String, dynamic>>?> getAllChangesInADay(DateTime date) async {
    _db ??= await initializeDb();
    return await _db?.rawQuery("SELECT * FROM $_progressInstanceTable WHERE date_updated=?", [date.toIso8601String().substring(0,10)]);
  }

  Future<int> dailyTotalSeconds(DateTime date) async {
    int counter = 0;
    List<Map<String, dynamic>>? finalList = await DbProvider.instance.getAllChangesInADay(date);
    for(var element in finalList!){
      counter += (element['seconds'] as int);
    }
    return counter;
  }
  Future<int> dailyTotalTasks(DateTime date) async {
    List<Map<String, dynamic>>? finalList = await DbProvider.instance.getAllChangesInADay(date);
    if(finalList!.isNotEmpty){
      int lastTask = finalList.first['task_id'] as int;
      int counter = 1;
      for(var element in finalList){
        if(element['task_id'] as int != lastTask){
          counter++;
          lastTask = element['task_id'] as int;
        }
      }
      return counter;
    }else{
      return 0;
    }
  }
  Future<List<String>> displayAllTasksThatDay(DateTime date) async{
    List<String> result = [];
    List<Map<String, dynamic>>? finalList = await DbProvider.instance.getAllChangesInADay(date);
    if(finalList!.isNotEmpty){
      int lastTask = finalList.first['task_id'] as int;
      result.add((await DbProvider.instance.queryTaskAlone(lastTask)).title);
      for( var element in finalList){
        if( (element['task_id'] as int) != lastTask){
          lastTask = element['task_id'] as int;
          result.add((await DbProvider.instance.queryTaskAlone(lastTask)).title);
        }
      }
      return result;
    }else{
      return result;
    }
  }
}

