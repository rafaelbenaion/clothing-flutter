// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCEwOqlyKsT0HcRnFax7Hx2cW6swQaDNYo',
    appId: '1:125329063547:web:f94e98d5e206f1f658acde',
    messagingSenderId: '125329063547',
    projectId: 'tp-flutter-univ',
    authDomain: 'tp-flutter-univ.firebaseapp.com',
    storageBucket: 'tp-flutter-univ.appspot.com',
    measurementId: 'G-Y5G0SLZVSB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB680t7I-u3T3e8FOpcc3oWa7bLcx1788Q',
    appId: '1:125329063547:android:c273b6d74154f69358acde',
    messagingSenderId: '125329063547',
    projectId: 'tp-flutter-univ',
    storageBucket: 'tp-flutter-univ.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBD5MtAGQ4lGjD2PEOPHKFnUBpmIfCNhdA',
    appId: '1:125329063547:ios:4962b1b90ac7856158acde',
    messagingSenderId: '125329063547',
    projectId: 'tp-flutter-univ',
    storageBucket: 'tp-flutter-univ.appspot.com',
    iosBundleId: 'com.example.tpClothing',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBD5MtAGQ4lGjD2PEOPHKFnUBpmIfCNhdA',
    appId: '1:125329063547:ios:4962b1b90ac7856158acde',
    messagingSenderId: '125329063547',
    projectId: 'tp-flutter-univ',
    storageBucket: 'tp-flutter-univ.appspot.com',
    iosBundleId: 'com.example.tpClothing',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEwOqlyKsT0HcRnFax7Hx2cW6swQaDNYo',
    appId: '1:125329063547:web:6b4545d99b73894658acde',
    messagingSenderId: '125329063547',
    projectId: 'tp-flutter-univ',
    authDomain: 'tp-flutter-univ.firebaseapp.com',
    storageBucket: 'tp-flutter-univ.appspot.com',
    measurementId: 'G-1JE261N0Z3',
  );

}