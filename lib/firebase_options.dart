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
    apiKey: 'AIzaSyA01lNFbKJ2Lzy0ZDUtVHO6B86PuYr1RNI',
    appId: '1:688039757321:android:0eb1be8aa11eabdf2c5ad8',
    messagingSenderId: '688039757321',
    projectId: 'chat-app-6c0b0',
    storageBucket: 'chat-app-6c0b0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBv3JNThTK-phRJw4FcHW02sMjIk7AGQSU',
    appId: '1:688039757321:ios:0b22aa05f4a219202c5ad8',
    messagingSenderId: '688039757321',
    projectId: 'chat-app-6c0b0',
    storageBucket: 'chat-app-6c0b0.firebasestorage.app',
    androidClientId: '688039757321-r9h40a85d8737thkiab1td0rafgjvlei.apps.googleusercontent.com',
    iosClientId: '688039757321-bc6dk7sgf6eban3auolp59dtb0fh2k5e.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

}