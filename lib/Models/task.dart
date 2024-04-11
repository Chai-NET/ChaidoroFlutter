class Task {

  final int? id;
  final String title;
  final int seconds;
  final DateTime dateCreated;
  final DateTime? dateUpdated;

  const Task({
    required this.title,
    required this.dateCreated,
    required this.seconds,
    this.id,
    this.dateUpdated,
  });
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'seconds' : seconds,
      'date_created' : dateCreated.toIso8601String(),
      'date_updated' : (dateUpdated ?? dateCreated).toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, seconds: $seconds, dateCreated: ${dateCreated.toIso8601String()}, dateUpdated:${(dateUpdated ?? dateCreated).toIso8601String()}';
  }
  factory Task.fromSqliteDoc(Map<String, dynamic> map) => Task(id: map['id'] as int,title: map['title'] as String ,dateCreated:DateTime.parse(map['date_created'] as String,), dateUpdated: DateTime.parse(map['date_updated'] as String), seconds: map['seconds'] as int );
}

class SubTask {
  final int? subtaskId;
  final int taskId;
  final String subtitle;
  final int toggleOn;

  const SubTask({
    this.subtaskId,
    required this.taskId,
    required this.subtitle,
    required this.toggleOn,
  });

  Map<String, dynamic> toMap(){
    return {
      'sub_task_id' : subtaskId,
      'task_id' : taskId,
      'sub_title' : subtitle,
      'bool' : toggleOn,
    };
  }

  @override
  String toString() {
    return 'SubTask{id: $taskId, taskId: $subtaskId, subtitle: $subtitle, bool: $toggleOn}';
  }

  factory SubTask.fromSqliteDoc(Map<String, dynamic> map) => SubTask(subtaskId: map['sub_task_id'] as int,taskId: map['task_id'] as int ,subtitle: map['sub_title'] as String ,toggleOn: (map['bool'] ?? 0) as int );
}