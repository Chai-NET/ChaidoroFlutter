class ProgressInstance{
  final DateTime dateUpdated;
  final int taskId;
  final int seconds;

  ProgressInstance({
    required this.dateUpdated,
    required this.taskId,
    required this.seconds,
});

  Map<String, dynamic> toMap() => { 'date_updated' : dateUpdated.toIso8601String().substring(0,10), 'task_id' : taskId, 'seconds' : seconds };

  factory ProgressInstance.fromSqliteDoc(Map<String, dynamic> map) => ProgressInstance(dateUpdated: DateTime.parse(map['date_updated'] as String), taskId: map['task_id'] as int, seconds: map['seconds'] as int);


}