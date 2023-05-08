import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../models/tasks.dart';

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE User(
        userId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        points INTEGER
      )
      """);
    await database.execute("""CREATE TABLE Tasks(
        taskId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        task TEXT,
        target INTEGER,
        achieved INTEGER,
        percentage REAL,
        taskPoints INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        fkUserId INTEGER NOT NULL, FOREIGN KEY (fkUserId) REFERENCES User (userId)
      )
      """);
    await database.execute("""CREATE TABLE UserSummary(
        SId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        createdAt TIMESTAMP NOT NULL,
        totalPointsPerDay INTEGER,
        fkUserId INTEGER NOT NULL, FOREIGN KEY (fkUserId) REFERENCES User (userId)
      )
      """);
  }
// id: the id of a item
// task, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'small_challenges.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //User operations
  // Create new item
  static Future<int> insertUser(int points) async {
    final db = await DatabaseHelper.db();
    //final SharedPreferences prefs = await _prefs;

    final userInfo = {'points': points};
    final userId = await db.insert('User', userInfo,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return userId;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseHelper.db();
    return db.query('User', orderBy: "userId");
  }

  // Get a single item by id
  //We don't use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getUserId(int userId) async {
    final db = await DatabaseHelper.db();
    return db.query('User', where: "userId = ?", whereArgs: [userId], limit: 1);
  }

  // Update an item by id
  static Future<int> updateUser(int userId, int points) async {
    final db = await DatabaseHelper.db();

    final userInfo = {
      'points': points,
    };

    final result = await db
        .update('User', userInfo, where: "userId = ?", whereArgs: [userId]);
    return result;
  }

  // Delete User
  static Future<void> deleteUser(int userId) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("User", where: "userId = ?", whereArgs: [userId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Summery operations
  static Future<int> insertUserSummary(
      int totalPointsPerDay, int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime createdAt = DateTime.now();
    String createdAtStr = createdAt.toString().substring(0, 10);

    final userSummary = {
      'createdAt': createdAtStr,
      'totalPointsPerDay': totalPointsPerDay,
      'fkUserId': fkUserId
    };
    final summaryId = await db.insert('UserSummary', userSummary,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return summaryId;
  }

  static Future<int> collectFinalTotalPoints(int fkUserId) async {
    final db = await DatabaseHelper.db();
    final sum = sql.Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(totalPointsPerDay) AS _totalPoints FROM UserSummary WHERE fkUserId =$fkUserId"));
    if (sum == null) {
      return 0;
    } else {
      return sum.toInt();
    }
  }

  static Future<List> getDateOfUserSummary(int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime now = DateTime.now();
    String todayDate = now.toString().substring(0, 10);
    final queryResult = await db.rawQuery(
        "SELECT date(datetime(createdAt,'localtime')) AS createdAtStr FROM UserSummary WHERE createdAtStr == '$todayDate' AND fkUserId =$fkUserId");

    return queryResult;
  }

  static Future<List> getAllDatesOfUserSummary(int fkUserId) async {
    final db = await DatabaseHelper.db();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT createdAt FROM UserSummary");
    return queryResult.toList();
  }

  static Future<int?> deleteUnusedSummaryRecord(int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime now = DateTime.now();
    String todayDate = now.toString().substring(0, 10);
    try {
      await db.rawQuery(
          "DELETE FROM UserSummary WHERE fkUserId =$fkUserId AND date(datetime(createdAt, 'localtime')) == '$todayDate'");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Task operations
  //insert
  static Future<int> insertTask(String? task, int target, int achieved,
      double percentage, int taskPoints, int fkUserId) async {
    final db = await DatabaseHelper.db();

    final data = {
      'task': task,
      'target': target,
      'achieved': achieved,
      'percentage': percentage,
      'taskPoints': taskPoints,
      'fkUserId': fkUserId
    };
    final taskId = await db.insert('Tasks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return taskId;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await DatabaseHelper.db();
    return db.query('Tasks', orderBy: "taskId");
  }

  // retrieve data
  static Future<List<Tasks>> retrieveTodayTasksByUserId(int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime now = DateTime.now();
    String todayDate = now.toString().substring(0, 10);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "SELECT *, date(datetime(createdAt,'localtime')) AS createdAtStr FROM Tasks WHERE createdAtStr == '$todayDate' AND fkUserId =$fkUserId");

    return queryResult.map((e) => Tasks.fromMap(e)).toList();
  }

  static Future<List<Tasks>> retrieveTaskTaskIds(int taskId) async {
    final db = await DatabaseHelper.db();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM Tasks WHERE taskId =$taskId');
    return queryResult.map((e) => Tasks.fromMap(e)).toList();
  }

  static Future<int> countCompleteTasks(int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime now = DateTime.now();
    String todayDate = now.toString().substring(0, 10);
    final count = sql.Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM (SELECT fkUserId, percentage, date(datetime(createdAt, 'localtime')) AS createdAtStr FROM Tasks WHERE createdAtStr == '$todayDate') AS CountDates WHERE fkUserId =$fkUserId AND percentage ==100.0"));

    if (count == null) {
      return 0;
    } else {
      return count.toInt();
    }
  }

  static Future<int> countTasks(int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime now = DateTime.now();
    String todayDate = now.toString().substring(0, 10);
    final count = sql.Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM (SELECT fkUserId, date(datetime(createdAt, 'localtime')) AS createdAtStr FROM Tasks WHERE createdAtStr == '$todayDate') AS CountDates WHERE fkUserId =$fkUserId"));

    if (count == null) {
      return 0;
    } else {
      return count.toInt();
    }
  }

  static Future<int> collectTasksPoints(int fkUserId) async {
    final db = await DatabaseHelper.db();
    DateTime now = DateTime.now();
    String todayDate = now.toString().substring(0, 10);

    final sum = sql.Sqflite.firstIntValue(await db.rawQuery(
        "SELECT SUM(taskPoints) AS _taskPoints FROM (SELECT fkUserId, taskPoints, percentage, date(datetime(createdAt, 'localtime')) AS createdAtStr FROM Tasks WHERE createdAtStr == '$todayDate') AS CountDates WHERE fkUserId =$fkUserId AND percentage ==100.0"));
    if (sum == null) {
      return 0;
    } else {
      return sum.toInt();
    }
  }

  // Update an item by id
  static Future<int> updateTask(int taskId, String task, int target,
      int achieved, double percentage, int taskPoints) async {
    final db = await DatabaseHelper.db();

    final data = {
      'task': task,
      'target': target,
      'achieved': achieved,
      'percentage': percentage,
      'taskPoints': taskPoints,
      //'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('Tasks', data, where: "taskId = ?", whereArgs: [taskId]);
    return result;
  }

  static Future<int> updateTaskPoints(int taskId, int taskPoints) async {
    final db = await DatabaseHelper.db();

    final taskPoints_ = {
      'taskPoints': taskPoints,
    };

    final result = await db
        .update('Tasks', taskPoints_, where: "taskId = ?", whereArgs: [taskId]);
    return result;
  }

  // Delete
  static Future<void> deleteTask(int taskId) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("Tasks", where: "taskId = ?", whereArgs: [taskId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

class SaveUserInfo {
  static int? userId;
  setUserId(int uId) {
    userId = uId;
  }

  getUserId() {
    return userId;
  }
}
