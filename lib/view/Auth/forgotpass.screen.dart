import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_helper/view/Auth/login.screen.dart';
import 'package:note_helper/view/widget/custom_button.dart';

import '../../Bloc/ForgotBloc/forgot_pass_bloc.dart';
import '../widget/flutter.toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController fEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    fEmailController.dispose();
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
                              hintText: "John@gmail.com",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  BlocListener<ForgotPassBloc, ForgotPassState>(
                    listener: (context, state) {
                      if (state is ForgotPassLoading) {
                        loading = true;
                      }
                      if (state is ForgotPassFailer) {
                        loading = false;
                        FlutterToast().toastMessage(state.errorMessage);
                      }
                      if (state is ForgotPassSuccess) {
                        loading = false;
                        FlutterToast()
                            .toastMessage(state.snakeMessage.toString());
                        Navigator.pop(context);
                      }
                    },
                    child: CustomButton(
                      isLoading: loading,
                      title: 'R E C O V E R ',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPassBloc>().add(
                              ForgotPassButtonPressedEvent(
                                  email: fEmailController.text.trim()));
                        }
                      },
                    ),
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
