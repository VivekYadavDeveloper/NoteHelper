import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_helper/view/verifiePhoneNum/verifie.phone.number.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';
import '../widget/custom_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  // void dispose() {
  //   phoneController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Center(child: Text("N U M B E R  L O G I N")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Phone Number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Phone Number"),
                    hintText: "+1 1234567890",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                isLoading: loading,
                title: 'L O G I N',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  //*** Through Firebase Instance We're
                  // Gonna Verify The Phone Num.
                  _firebaseAuth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      //** Verification Exception
                      verificationFailed: (e) {
                        setState(() {
                          loading = false;
                        });
                        FlutterToast().toastMessage(e.toString());
                      },
                      //*** In Code Sent We Get Two Para
                      // Things (VerificationID , token(Which is Integer And Can't be null)
                      // )
                      codeSent: (String verificationID, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyPhoneNumberScreen(
                                    verificationID: verificationID)));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        FlutterToast().toastMessage(e.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                  //  **1844
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}
