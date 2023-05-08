class Tasks {
  late final int taskId;
  late final String task;
  late final int target;
  late final int achieved;
  late final double percentage;
  late final int taskPoints;
  late final String createdAt;
  late final int fkUserId;

  Tasks(
      {required this.taskId,
      required this.task,
      required this.target,
      required this.achieved,
      required this.percentage,
      required this.taskPoints,
      required this.createdAt,
      required this.fkUserId});

  Tasks.fromMap(dynamic obj) {
    taskId = obj['taskId'];
    task = obj['task'];
    target = obj['target'];
    achieved = obj['achieved'];
    percentage = obj['percentage'];
    taskPoints = obj['taskPoints'];
    fkUserId = obj['fkUserId'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'taskId': taskId,
      'task': task,
      'target': target,
      'achieved': achieved,
      'percentage': percentage,
      'taskPoints': taskPoints,
      'createdAt': createdAt,
      'FK_userId': fkUserId,
    };
    return map;
  }
}
