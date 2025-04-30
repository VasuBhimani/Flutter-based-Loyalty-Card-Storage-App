import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      apiKey: "AIzaSyBGbmmSnlIPe5T9D6Hw7kESG0236OmlPsE",
      authDomain: "loyalty-card-storage-app-2a98d.firebaseapp.com",
      projectId: "loyalty-card-storage-app-2a98d",
      storageBucket: "loyalty-card-storage-app-2a98d.firebasestorage.app",
      messagingSenderId: "392428631464",
      appId: "1:392428631464:web:253fc0149ad1ff5762199d",
      measurementId: "G-KC2ZKVFV8Y");

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyBGbmmSnlIPe5T9D6Hw7kESG0236OmlPsE",
      authDomain: "loyalty-card-storage-app-2a98d.firebaseapp.com",
      projectId: "loyalty-card-storage-app-2a98d",
      storageBucket: "loyalty-card-storage-app-2a98d.firebasestorage.app",
      messagingSenderId: "392428631464",
      appId: "1:392428631464:web:253fc0149ad1ff5762199d",
      measurementId: "G-KC2ZKVFV8Y");

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBGbmmSnlIPe5T9D6Hw7kESG0236OmlPsE",
    authDomain: "loyalty-card-storage-app-2a98d.firebaseapp.com",
    projectId: "loyalty-card-storage-app-2a98d",
    storageBucket: "loyalty-card-storage-app-2a98d.firebasestorage.app",
    messagingSenderId: "392428631464",
    appId: "1:392428631464:web:253fc0149ad1ff5762199d",
    measurementId: "G-KC2ZKVFV8Y",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyBGbmmSnlIPe5T9D6Hw7kESG0236OmlPsE",
    authDomain: "loyalty-card-storage-app-2a98d.firebaseapp.com",
    projectId: "loyalty-card-storage-app-2a98d",
    storageBucket: "loyalty-card-storage-app-2a98d.firebasestorage.app",
    messagingSenderId: "392428631464",
    appId: "1:392428631464:web:253fc0149ad1ff5762199d",
    measurementId: "G-KC2ZKVFV8Y",
  );
}
