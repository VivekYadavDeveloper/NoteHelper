class PostModel {
  late String taskID;
  late String taskName;
  late int dt;
  late String profileImage;

  PostModel(
      {required this.taskID,
      required this.taskName,
      required this.dt,
      required this.profileImage});

  static PostModel fromMap(Map<Object?, dynamic> map) {
    return PostModel(
      taskID: map['taskID'],
      taskName: map['taskName'],
      dt: map['dt'],
      profileImage: map['profileImage'].toString(),
    );
  }
}
