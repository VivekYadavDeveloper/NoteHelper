import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_helper/view/Auth/login.screen.dart';
import 'package:note_helper/view/widget/custom_button.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

import '../../Bloc/SignupBloc/signup_bloc.dart';
import '../../core/firebase/services/session.manager.dart';
import '../homeScreen/home.screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                      spacing: 20,
                      children: <Widget>[
                        /* Name TextField */
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Name"),
                            hintText: "John Doe",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        /* Email TextField */

                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Email';
                            }
                            if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Email"),
                            hintText: "you@mail.com",
                            border: const OutlineInputBorder(),
                          ),
                        ),

                        /* Password TextField */
                        TextFormField(
                          obscureText: !isPasswordVisible,
                          textInputAction: TextInputAction.next,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                            ).hasMatch(value)) {
                              return """Password must include:
                      - 1 Upper case
                      - 1 lowercase
                      - 1 Numeric Number
                      - 1 Special Character""";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            hintText: "Password",
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                }); // Updates the UI.
                              },
                              child: !isPasswordVisible
                                  ? const Icon(Icons.visibility,
                                      color: Colors.white70)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.white70),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        /* Confirm Password TextField */
                        TextFormField(
                          obscureText: !isConfirmPasswordVisible,
                          textInputAction: TextInputAction.done,
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(
                            label: const Text("Confirm Password"),
                            hintText: "Confirm Password",
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                }); // Updates the UI.
                              },
                              child: !isConfirmPasswordVisible
                                  ? const Icon(Icons.visibility,
                                      color: Colors.white70)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.white70),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                BlocListener<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    } else if (state is SignupFailer) {
                      setState(() {
                        isLoading = false;
                      });
                      FlutterToast().toastMessage(state.errorMessage);
                    } else if (state is SignupSuccess) {
                      setState(() {
                        isLoading = false;
                      });
                      FlutterToast()
                          .toastMessage(state.snakeMessage.toString());
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const HomeScreen()));
                    }
                  },
                  child: CustomButton(
                    isLoading: isLoading,
                    title: 'S I G N U P',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignupBloc>().add(SignupButtonPressed(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            name: nameController.text
                                .trim())); // createAccount();
                      }
                    },
                  ),
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
