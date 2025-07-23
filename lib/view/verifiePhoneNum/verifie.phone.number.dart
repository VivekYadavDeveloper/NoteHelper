import 'package:flutter/material.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key, required this.verificationID});

  final String verificationID;

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("V E R I F I E  N U M B E R")),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return Column(
          children: <Widget>[
            Center(
              child: Text("Verifies Number"),
            )
          ],
        );
      }),
    );
  }
}
