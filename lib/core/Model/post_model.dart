import 'dart:convert';
import 'package:flutter/foundation.dart';

class PostModel {
  final String title;
  final String taskID;
  final String taskName;
  final int dt;
  final String profileImage;

  PostModel({
    required this.title,
    required this.taskID,
    required this.taskName,
    required this.dt,
    required this.profileImage,
  });

  factory PostModel.fromMap(Map<Object?, dynamic> map) {
    String taskNameStr = '';
    final taskNameRaw = map['taskName'];

    if (taskNameRaw != null) {
      if (taskNameRaw is String) {
        taskNameStr = taskNameRaw;
      } else {
        taskNameStr = jsonEncode(taskNameRaw);
      }
    }

    debugPrint('Loaded taskName: $taskNameStr');

    return PostModel(
      title: map['title'] ?? '',
      taskID: map['taskID'] ?? '',
      taskName: taskNameStr,
      dt: map['dt'] ?? 0,
      profileImage: map['profileImage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'taskID': taskID,
      'taskName': taskName,
      'dt': dt,
      'profileImage': profileImage,
    };
  }
}
