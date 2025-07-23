import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../view/widget/flutter.toast.dart';

part 'forgot_pass_event.dart';

part 'forgot_pass_state.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  ForgotPassBloc() : super(ForgotPassInitial()) {
    on<ForgotPassButtonPressedEvent>((event, emit) async {
      try {
        emit(ForgotPassLoading());
        FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
        FlutterToast()
            .toastMessage("Please Check Your Email To Recover Your Password");
      } on FirebaseException catch (e) {
        emit(ForgotPassFailer(errorMessage: e.message ?? "An error occurred"));
      } catch (e) {
        emit(ForgotPassFailer(errorMessage: e.toString()));
      }
    });
  }
}
