import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';
import 'package:note_helper/view/Auth/forgotpass.screen.dart';
import 'package:note_helper/view/Auth/login.with.phone.dart';
import 'package:note_helper/view/widget/custom_button.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

import '../../Bloc/LoginBloc/login_bloc.dart';
import '../homeScreen/home.screen.dart';
import 'signup.screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(child: Text("L O G I N  S C R E E N")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                // Regular expression for email validation
                                if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
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
                              obscureText: !isPasswordVisible,
                              keyboardType: TextInputType.visiblePassword,
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
                                suffixIcon: InkWell(
                                  onTap: () {
                                    isPasswordVisible = !isPasswordVisible;
                                    setState(() {});
                                  },
                                  child: !isPasswordVisible
                                      ? const Icon(Icons.visibility,
                                          color: Colors.white70)
                                      : const Icon(Icons.visibility_off,
                                          color: Colors.white70),
                                ),
                                label: const Text("Password"),
                                hintText: "Password",
                                helperText: "Enter Your Password",
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    //**** Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen()),
                                  (route) => true);
                            },
                            child: const Text("Forgot Password ?")),
                      ],
                    ),
                    const SizedBox(height: 25),
                    BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginLoadingState) {
                          loading = true;
                        }
                        if (state is LoginFailerState) {
                          loading = false;
                          FlutterToast().toastMessage(state.errorMessage);
                        }
                        if (state is LoginSuccessState) {
                          loading = false;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false);
                          FlutterToast().toastMessage(state.snackMsg!);
                        }
                      },
                      child: CustomButton(
                        isLoading: loading,
                        title: 'L O G I N',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(
                                LoginButtonPressedEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()));
                          }
                        },
                      ),
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
                        child: const Center(
                            child: Text("Login With Phone Number")),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
