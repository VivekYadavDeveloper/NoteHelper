import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
      int dt = DateTime.now().millisecondsSinceEpoch;

      final DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('Post').child(user.uid);


      String taskID = databaseRef.push().key.toString();

      // ✅ JSON String decode karke native format mein save karo
      final taskNameDecoded = jsonDecode(event.description);

      await databaseRef.child(taskID).set({
        'dt': dt,
        'title': event.title.trim(),
        'taskName': taskNameDecoded, // ✅\ List format — not String
        'taskID': taskID,
        'profileImage': user.photoURL ?? '',
      });

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
      // ✅ Yahan bhi decode karo
      final taskNameDecoded = jsonDecode(event.description);

      await FirebaseDatabase.instance
          .ref()
          .child('Post')
          .child(user.uid)
          .child(event.taskId)
          .update({
        'title': event.title.trim(),
        'taskName': taskNameDecoded, // ✅ List format — not String
      });

      emit(CreateNoteSuccess());
    }
  } on FirebaseException catch (e) {
    emit(CreateNoteFailure(e.toString()));
  }
});
 
  }
}