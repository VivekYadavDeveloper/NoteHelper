import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_helper/core/firebase/services/session.manager.dart';
import 'package:note_helper/view/homeScreen/home.screen.dart';
import 'package:note_helper/view/loginAuth/login.screen.dart';

class SplashServices {
  final firebaseAuthentication = FirebaseAuth.instance;

  void isLogin(BuildContext context) {
    //*** To Check The Current User Is Login Or Not
    final user = firebaseAuthentication.currentUser;
    if (user != null) {
      // SessionController().userID = user.uid.toString();
      Timer(const Duration(milliseconds: 3000), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } else {
      Timer(const Duration(milliseconds: 3000), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
