import 'dart:developer' as developer show log;

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginButtonPressedEvent>((event, emit) async {
      try {
        emit(LoginLoadingState());

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.email, password: event.password);

        if (userCredential.user != null) {
          emit(LoginSuccessState(snackMsg: "Login Successfully"));
          var pref = await SharedPreferences.getInstance();
          pref.setString("UID", userCredential.user!.uid);
        }
        developer.log("Login Key----->  ${userCredential.user!.uid.toString()}",
            name: "LoginBloc");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginFailerState("No user found for that email."));
        } else if (e.code == 'wrong-password') {
          emit(LoginFailerState("Invalid credentials. Please try again."));
        }
      }
    });
  }
}
