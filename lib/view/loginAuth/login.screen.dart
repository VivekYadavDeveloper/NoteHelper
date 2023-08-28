import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_helper/core/firebase/services/session.manager.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';
import 'package:note_helper/view/loginAuth/login.with.phone.dart';
import 'package:note_helper/view/widget/custom_button.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

import '../homeScreen/home.screen.dart';
import '../signUpScreen/signup.screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _firebaseAuthentication = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //**** Firebase Authentication LogIn
  void login() {
    setState(() {
      loading = true;
    });
    _firebaseAuthentication
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
          // SessionController().userID =value.user!.uid.toString();
      FlutterToast().toastMessage(value.user!.email.toString());

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      setState(() {
        loading = false;
      });
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
          automaticallyImplyLeading: false,
          title: const Center(child: Text("L O G I N  S C R E E N")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
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
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text("Password"),
                              hintText: "Password",
                              helperText: "Enter Your Password",
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
                    title: 'L O G I N',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't Have a Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text("Sign UP")),
                    ],
                  ),
                  const SizedBox(height: 30),

                  //**** Login With Phone Number
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginWithPhoneNumber()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.appBarColor)),
                      child:
                          const Center(child: Text("Login With Phone Number")),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
