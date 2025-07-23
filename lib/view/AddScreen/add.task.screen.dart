import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:note_helper/view/widget/custom_button.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

class AddPTaskScreen extends StatefulWidget {
  const AddPTaskScreen({super.key});

  @override
  State<AddPTaskScreen> createState() => _AddPTaskScreenState();
}

class _AddPTaskScreenState extends State<AddPTaskScreen> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  /*Create Task Function "OLD"*/

  // void createTask() {
  //   setState(() {
  //     loading = true;
  //   });
  //   //*** To Create a Different "ID" For Different Task
  //   //*** We Use DateTime.now Function
  //   databaseRef.child(userID).set({
  //     'id': userID,
  //     'title': taskController.text.trim().toString()
  //   }).then((value) {
  //     FlutterToast().toastMessage("Task Created");
  //     debugPrint(taskController.text);
  //     setState(() {
  //       loading = false;
  //     });
  //     Navigator.pop(context);
  //   }).onError((error, stackTrace) {
  //     FlutterToast().toastMessage(error.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("C R E A T E  T A S K"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Create An Title';
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      controller: titleController,
                      decoration: const InputDecoration(
                        label: Text("Title.."),
                        hintText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Create An Task';
                        }
                        return null;
                      },
                      maxLines: 5,
                      keyboardType: TextInputType.emailAddress,
                      controller: taskController,
                      decoration: const InputDecoration(
                        label: Text("Your Task...."),
                        hintText: "Your Task",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                  isLoading: loading,
                  title: "A D D  T A S K",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (taskController.text.trim().isEmpty ||
                          titleController.text.trim().isEmpty) {
                        FlutterToast()
                            .toastMessage("Please Provide The Task Or Title");
                        return;
                      }
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        String uID = user.uid;
                        int dt = DateTime.now().millisecondsSinceEpoch;
                        //*** Create Database Instance Of Firebase Database
                        //**** With Reference(In Firebase RealTime Database We Create 'Post' Node/Table
                        final DatabaseReference databaseRef = FirebaseDatabase
                            .instance
                            .ref()
                            .child('Post')
                            .child(uID);
                        String taskID = databaseRef.push().key.toString();
                        await databaseRef.child(taskID).set({
                          'dt': dt,
                          'title': titleController.text.trim(),
                          'taskName': taskController.text.trim(),
                          'taskID': taskID
                        }).then((value) {
                          FlutterToast().toastMessage("Task Created");
                          debugPrint(taskController.text);
                          setState(() {
                            loading = false;
                            Navigator.pop(context);
                          });
                        });
                      }
                      // createTask();
                    }
                    // setState(() {
                    //   loading = true;
                    // });
                    // //*** To Create a Different "ID" For Different Task
                    // //*** We Use DateTime.now Function
                    // databaseRef.child(id).set({
                    //   'id': id,
                    //   'title': taskController.text.toString()
                    // }).then((value) {
                    //   FlutterToast().toastMessage("Task Created");
                    //   debugPrint(taskController.text);
                    //   setState(() {
                    //     loading = false;
                    //   });
                    //   Navigator.pop(context);
                    // }).onError((error, stackTrace) {
                    //   FlutterToast().toastMessage(error.toString());
                    //   setState(() {
                    //     loading = false;
                    //   });
                    // });
                  })
            ],
          );
        }),
      ),
    );
  }
}
