import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_helper/view/Auth/login.screen.dart';
import 'package:note_helper/view/widget/custom_button.dart';

import '../widget/flutter.toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fEmailController = TextEditingController();

  final FirebaseAuth _firebaseAuthentication = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    fEmailController.dispose();
    super.dispose();
  }

  //**** Firebase Authentication LogIn
  void forgot() {
    setState(() {
      loading = true;
    });
    _firebaseAuthentication
        .sendPasswordResetEmail(email: fEmailController.text.toString())
        .then((value) {
      // print("Login Key----->  ${userID.toString()}");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));

      setState(() {
        loading = false;
      });
      FlutterToast()
          .toastMessage("Please Check Your Email To Recover Your Password");
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      FlutterToast().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text("F O R G O T P A S S W O R D"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: fEmailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text("Email"),
                              hintText: "Email",
                              helperText: "Enter Your Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    isLoading: loading,
                    title: 'R E C O V E R ',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        forgot();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
