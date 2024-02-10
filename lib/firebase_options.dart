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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCh0FuZk8-QhS88lqBC-91ELpYd9_sEaSk',
    appId: '1:218249155608:web:df2a086994473117085f6d',
    messagingSenderId: '218249155608',
    projectId: 'otk-todo',
    authDomain: 'otk-todo.firebaseapp.com',
    storageBucket: 'otk-todo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLm4cfBWQ1iaWKjT3S_qxszcOPsGYgtg8',
    appId: '1:218249155608:android:71b28952fc07e85a085f6d',
    messagingSenderId: '218249155608',
    projectId: 'otk-todo',
    storageBucket: 'otk-todo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUgTkRXT8rcf8bc0zP3AiV04PcGXwS4DQ',
    appId: '1:218249155608:ios:55c808aa39ba8f64085f6d',
    messagingSenderId: '218249155608',
    projectId: 'otk-todo',
    storageBucket: 'otk-todo.appspot.com',
    androidClientId: '218249155608-8puvgpo80v766q3pg0p6pmflfji74cll.apps.googleusercontent.com',
    iosClientId: '218249155608-fh6nahkkbsmbbp2d4an4eg9p43e2dmo6.apps.googleusercontent.com',
    iosBundleId: 'com.shuvro.todo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUgTkRXT8rcf8bc0zP3AiV04PcGXwS4DQ',
    appId: '1:218249155608:ios:81f3ac2a4e5d959e085f6d',
    messagingSenderId: '218249155608',
    projectId: 'otk-todo',
    storageBucket: 'otk-todo.appspot.com',
    androidClientId: '218249155608-8puvgpo80v766q3pg0p6pmflfji74cll.apps.googleusercontent.com',
    iosClientId: '218249155608-spamrf2ftckufnkaeucnl8n7tbkgucgb.apps.googleusercontent.com',
    iosBundleId: 'com.shuvro.todo.RunnerTests',
  );
}