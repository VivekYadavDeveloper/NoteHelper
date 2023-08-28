// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpwOcCiW4vsw7ZdEN9eBAp31jAdwJ114A',
    appId: '1:437103178955:android:45b29891d930ac0f48574e',
    messagingSenderId: '437103178955',
    projectId: 'notehelper-98a0c',
    databaseURL: 'https://notehelper-98a0c-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'notehelper-98a0c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6n4YMWRtHuxwzjuS74QD6PzvkPvZWi_A',
    appId: '1:437103178955:ios:619be818edc84a3248574e',
    messagingSenderId: '437103178955',
    projectId: 'notehelper-98a0c',
    databaseURL: 'https://notehelper-98a0c-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'notehelper-98a0c.appspot.com',
    androidClientId: '437103178955-qetbel5olrvjg8qubb4hqcjmhvt14fr6.apps.googleusercontent.com',
    iosClientId: '437103178955-s5pnrjpbdhs0qurdvqan1ggng98ph2nl.apps.googleusercontent.com',
    iosBundleId: 'com.phenoxiod.noteHelper',
  );
}