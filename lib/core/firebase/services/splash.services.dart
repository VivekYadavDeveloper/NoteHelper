import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:note_helper/view/homeScreen/home.screen.dart';
import 'package:note_helper/view/loginAuth/login.screen.dart';

class SplashServices {
  final firebaseAuthentication = FirebaseAuth.instance;

  Future<void> isLogin(BuildContext context) async {
    //*** To Check The Current User Is Login Or Not
    final user = firebaseAuthentication.currentUser;
    if (user != null) {
      Timer(const Duration(milliseconds: 3000), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      });
    } else {
      Timer(const Duration(milliseconds: 3000), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      });
    }
  }
}
/*https://github.com/PearlOrganisationApplications/Peeptoon/blob/main/lib/presentation/screens/optScreen/otp.screen.dart*/