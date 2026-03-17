import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../view/widget/flutter.toast.dart';

part 'create_note_event.dart';
part 'create_note_state.dart';

class CreateNoteBloc extends Bloc<CreateNoteEvent, CreateNoteState> {
  CreateNoteBloc() : super(CreateNoteInitial()) {

    // ── Create ───────────────────────────────────────
    on<CreateNoteButtonEvent>((event, emit) async {
      emit(CreateNoteLoading());
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uID = user.uid;
          int dt = DateTime.now().millisecondsSinceEpoch;
          final DatabaseReference databaseRef =
              FirebaseDatabase.instance.ref().child('Post').child(uID);
          String taskID = databaseRef.push().key.toString();
          await databaseRef.child(taskID).set({
            'dt': dt,
            'title': event.title.trim(),
            'taskName': event.description.trim(),
            'taskID': taskID,
          });
          FlutterToast().toastMessage("Task Created");
          emit(CreateNoteSuccess());
        }
      } on FirebaseException catch (e) {
        emit(CreateNoteFailure(e.toString()));
      }
    });

    // ── Update ───────────────────────────────────────
    on<UpdateNoteButtonEvent>((event, emit) async {
      emit(CreateNoteLoading());
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uID = user.uid;
          final DatabaseReference databaseRef =
              FirebaseDatabase.instance.ref().child('Post').child(uID);
          await databaseRef.child(event.taskId).update({
            'title': event.title.trim(),
            'taskName': event.description.trim(),
          });
          FlutterToast().toastMessage("Task Updated");
          emit(CreateNoteSuccess());
        }
      } on FirebaseException catch (e) {
        emit(CreateNoteFailure(e.toString()));
      }
    });
  }
}