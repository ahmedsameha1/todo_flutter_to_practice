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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLyLG3nOw8QW3BtPVcnz2ZdvjMAVPc6nM',
    appId: '1:712265865835:web:942045716a9e9c62616f2e',
    messagingSenderId: '712265865835',
    projectId: 'flutter-chat-max-37d0b',
    authDomain: 'flutter-chat-max-37d0b.firebaseapp.com',
    storageBucket: 'flutter-chat-max-37d0b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpPn2LOj1GNb4Lr4mrKR86FoFdSLUGRI0',
    appId: '1:712265865835:android:4c57a26f82e62790616f2e',
    messagingSenderId: '712265865835',
    projectId: 'flutter-chat-max-37d0b',
    storageBucket: 'flutter-chat-max-37d0b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3rVBRVcTsD1jufNDze9papjp3T-ato8E',
    appId: '1:712265865835:ios:2872b9c3a8613850616f2e',
    messagingSenderId: '712265865835',
    projectId: 'flutter-chat-max-37d0b',
    storageBucket: 'flutter-chat-max-37d0b.appspot.com',
    iosClientId: '712265865835-mumqfhf0eqiuni6jbvghc7aaotplstpn.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoFlutterToPractice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3rVBRVcTsD1jufNDze9papjp3T-ato8E',
    appId: '1:712265865835:ios:2872b9c3a8613850616f2e',
    messagingSenderId: '712265865835',
    projectId: 'flutter-chat-max-37d0b',
    storageBucket: 'flutter-chat-max-37d0b.appspot.com',
    iosClientId: '712265865835-mumqfhf0eqiuni6jbvghc7aaotplstpn.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoFlutterToPractice',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDLyLG3nOw8QW3BtPVcnz2ZdvjMAVPc6nM',
    appId: '1:712265865835:web:7dd69fdde5d93f05616f2e',
    messagingSenderId: '712265865835',
    projectId: 'flutter-chat-max-37d0b',
    authDomain: 'flutter-chat-max-37d0b.firebaseapp.com',
    storageBucket: 'flutter-chat-max-37d0b.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDLyLG3nOw8QW3BtPVcnz2ZdvjMAVPc6nM',
    appId: '1:712265865835:web:cabea6b49db9429e616f2e',
    messagingSenderId: '712265865835',
    projectId: 'flutter-chat-max-37d0b',
    authDomain: 'flutter-chat-max-37d0b.firebaseapp.com',
    storageBucket: 'flutter-chat-max-37d0b.appspot.com',
  );
}
