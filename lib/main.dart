import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_helper/Bloc/LoginBloc/login_bloc.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';
import 'Bloc/SignupBloc/signup_bloc.dart';
import 'firebase_options.dart';
import 'view/splashScreen/splash.screen.dart';

Color getRandomColor() {
  final Random random = Random();

  // Generate random values for the Red, Green, and Blue components.
  int red = random.nextInt(125) + 125; // 125-255 for a lighter color
  int green = random.nextInt(125) + 125; // 125-255 for a lighter color
  int blue = random.nextInt(125) + 125; // 125-255 for a lighter color

  // Set the Alpha component to 255 (fully opaque).
  int alpha = 255;

  // Create and return the Color object with the ARGB values.
  return Color.fromARGB(alpha, red, green, blue);
}

void main() async {
  DefaultFirebaseOptions.currentPlatform;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LoginBloc()),
    BlocProvider(create: (context) => SignupBloc()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N O T E  H E L P E R',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: AppColors.appBarColor),
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
