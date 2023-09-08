class PostModel {
  late String taskID;
  late String taskName;
  late int dt;

  PostModel({required this.taskID, required this.taskName, required this.dt});

  static PostModel fromMap(Map<Object?, dynamic> map) {
    return PostModel(
      taskID: map['taskID'],
      taskName: map['taskName'],
      dt: map['dt'],
    );
  }
}
