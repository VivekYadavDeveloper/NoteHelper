import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../view/widget/flutter.toast.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  /* To Store The User Data In Realtime Database To Get The User ID */
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('User');

  SignupBloc() : super(SignupInitial()) {
    on<SignupButtonPressed>((event, emit) async {
      emit(SignupLoading());
      try {
        /*Create Account Function*/
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        reference.child(userCredential.user!.uid.toString()).set({
          'uid': userCredential.user!.uid.toString(),
          'email': userCredential.user!.email.toString(),
          'onlineStatus': 'noOne',
          'profileImage': ''
        });
        if (userCredential.user!.uid != null) {
          emit(SignupSuccess(snakeMessage: "Account Created Successfully!"));
          FlutterToast().toastMessage('Account Created Successfully!');
        }
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          emit(SignupFailer("The password provided is too weak."));
        } else if (e.code == 'email-already-in-use') {
          emit(SignupFailer("The account already exists for that email."));
        }
      } catch (e) {
        emit(SignupFailer("$e"));
      }
    });
  }
}
