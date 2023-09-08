import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:note_helper/view/loginAuth/login.screen.dart';
import 'package:note_helper/view/widget/custom_button.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

import '../../core/firebase/services/session.manager.dart';
import '../homeScreen/home.screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? userID = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final FirebaseAuth _firebaseAuthentication = FirebaseAuth.instance;

  //**** To Store The User Data In Realtime Database
  //**** To Get The User ID
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('User');

  //*** Create Account Function
  void createAccount() {
    setState(() {
      isLoading = true;
    });
    _firebaseAuthentication
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) async {
      isLoading = false;

      // debugPrint("Account New Created😁 ---->${token.toString()}");
      reference
          .child(value.user!.uid
              .toString()) // Create Diff UID For Different User So That Data Will Not Leak
          .set({
        // We Set/Store the Data In RealTime Database
        'uid': value.user!.uid.toString(),
        'email': value.user!.email.toString(),
        'onlineStatus': 'noOne',
        'profileImage':''
      }).then((value) {
        isLoading = false;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }).onError((error, stackTrace) {
        isLoading = false;
      });
      FlutterToast().toastMessage('User Created Successfully');
      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      FlutterToast().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text(" S I G N U P   S C R E E N ")),
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
                  isLoading: isLoading,
                  title: 'S I G N U P',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      createAccount();
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already Have an Account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text("LogIn"))
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
