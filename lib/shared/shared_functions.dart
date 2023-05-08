import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../congrates.dart';
import '../data/dbhelper.dart';

Future<void> isTaskCompleted(double percentage, int taskId, int taskPoints,
    SharedPreferences prefs, BuildContext context) async {
  var totalPointsPerDay = await DatabaseHelper.collectTasksPoints(
      int.parse(prefs.getInt('_userId').toString()));
  final completeTask = await DatabaseHelper.countCompleteTasks(
      int.parse(prefs.getInt('_userId').toString()));
  final todayTask = await DatabaseHelper.countTasks(
      int.parse(prefs.getInt('_userId').toString()));
  final userSummaryDate = await DatabaseHelper.getDateOfUserSummary(
      int.parse(prefs.getInt('_userId').toString()));
  var finalTotalPoints = await DatabaseHelper.collectFinalTotalPoints(
      int.parse(prefs.getInt('_userId').toString()));

  if (userSummaryDate != null) {
    await DatabaseHelper.deleteUnusedSummaryRecord(
        int.parse(prefs.getInt('_userId').toString()));

    if (percentage == 100.0) {
      taskPoints = 1;
      await DatabaseHelper.updateTaskPoints(taskId, taskPoints);
      totalPointsPerDay = await DatabaseHelper.collectTasksPoints(
          int.parse(prefs.getInt('_userId').toString()));
    }

    if (todayTask >= 3 && completeTask == todayTask) {
      totalPointsPerDay = completeTask + 5;
      await DatabaseHelper.insertUserSummary(
          totalPointsPerDay, int.parse(prefs.getInt('_userId').toString()));

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CongratesWidget(
              finalTotalPoints: finalTotalPoints,
            ),
          ));
    } else {
      await DatabaseHelper.deleteUnusedSummaryRecord(
          int.parse(prefs.getInt('_userId').toString()));
      await DatabaseHelper.insertUserSummary(
          totalPointsPerDay, int.parse(prefs.getInt('_userId').toString()));
    }
    finalTotalPoints = await DatabaseHelper.collectFinalTotalPoints(
        int.parse(prefs.getInt('_userId').toString()));
    await DatabaseHelper.updateUser(
        int.parse(prefs.getInt('_userId').toString()), finalTotalPoints);
  }
}
