


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/NoteBloc/create_note_bloc.dart';
import '../widget/custom_button.dart';
import '../widget/flutter.toast.dart';

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

  @override
  void dispose() {
    taskController.dispose();
    taskController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("C R E A T E  T A S K"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                LayoutBuilder(builder: (context, BoxConstraints constraints) {
              return Column(children: <Widget>[
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the title';
                          }
                          return null;
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        controller: titleController,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                          hintText: "Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Add description for task';
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
                BlocListener<CreateNoteBloc, CreateNoteState>(
                    listener: (context, state) {
                      if (state is CreateNoteLoading) {
                        setState(() {
                          loading = true;
                        });
                      } else if (state is CreateNoteFailure) {
                        setState(() {
                          loading = false;
                        });
                        FlutterToast().toastMessage(state.errorMessage);
                      }
                      else if (state is CreateNoteSuccess) {
                        setState(() {
                          loading = false;
                          Navigator.pop(context);
                        });
                      } 
                    },
                    child: CustomButton(
                        isLoading: loading,
                        title: "A D D  T A S K",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<CreateNoteBloc>().add(
                                CreateNoteButtonEvent(
                                    title: titleController.text.trim(),
                                    description: taskController.text.trim()));
                            
                  
                          }
                        }))
              ]);
            })));
  }
}
