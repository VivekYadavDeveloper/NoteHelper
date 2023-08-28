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

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  //*** Create Sub Child In Child And .child That's All
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  //*** Create Database Instance Of Firebase Database
  //**** With Reference(In Firebase Database We Create 'Post' Node/Table
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  //**** Create Task Function
  void createTask() {
    setState(() {
      loading = true;
    });
    //*** To Create a Different "ID" For Different Task
    //*** We Use DateTime.now Function
    databaseRef
        .child(id)
        .set({'id': id, 'title': taskController.text.toString()}).then((value) {
      FlutterToast().toastMessage("Task Created");
      debugPrint(taskController.text);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      FlutterToast().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

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
                child: TextFormField(
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
              ),
              const SizedBox(height: 50),
              CustomButton(
                  isLoading: loading,
                  title: "A D D  T A S K",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      createTask();
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
