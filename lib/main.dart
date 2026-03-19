
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_helper/Bloc/HomeBloc/home_bloc.dart';
import 'package:note_helper/Bloc/LoginBloc/login_bloc.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';
import 'Bloc/ForgotBloc/forgot_pass_bloc.dart';
import 'Bloc/NoteBloc/create_note_bloc.dart';
import 'Bloc/SignupBloc/signup_bloc.dart';
import 'firebase_options.dart';
import 'view/splashScreen/splash.screen.dart';

void main() async {
  DefaultFirebaseOptions.currentPlatform;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LoginBloc()),
    BlocProvider(create: (context) => SignupBloc()),
    BlocProvider(create: (context) => ForgotPassBloc()),
    BlocProvider(create: (context) => CreateNoteBloc()),
    /*Agar BLoC ko app start hote hi kuch karna hai toh "..add(HomeLoadTasksEvent()"*/
    BlocProvider(create: (context) => HomeBloc()..add(HomeLoadTasksEvent())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N O T E  H E L P E R',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        FlutterQuillLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryColor,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColor),
        fontFamily: GoogleFonts.nunito().fontFamily,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
