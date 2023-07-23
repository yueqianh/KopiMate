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
    apiKey: 'AIzaSyArF55okxGLRNZ4I06DWkr1jq3B0AKsgJI',
    appId: '1:723657801401:web:6eed3637acb030256d2568',
    messagingSenderId: '723657801401',
    projectId: 'kopimate-470c2',
    authDomain: 'kopimate-470c2.firebaseapp.com',
    storageBucket: 'kopimate-470c2.appspot.com',
    measurementId: 'G-M9E2MY1NLX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv70tuVcZS1ql3fgqGR8lhXyuQ8EEf0eM',
    appId: '1:723657801401:android:74d13f0c8dd56f7f6d2568',
    messagingSenderId: '723657801401',
    projectId: 'kopimate-470c2',
    storageBucket: 'kopimate-470c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNj6TxhODW10iJUHTpejMFEgx6sF9eKhg',
    appId: '1:723657801401:ios:dc2be6eea227ebcf6d2568',
    messagingSenderId: '723657801401',
    projectId: 'kopimate-470c2',
    storageBucket: 'kopimate-470c2.appspot.com',
    iosClientId:
        '723657801401-ffb7sf6d0nl40q8dgvhdc03snmlp9uec.apps.googleusercontent.com',
    iosBundleId: 'com.example.kopimate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNj6TxhODW10iJUHTpejMFEgx6sF9eKhg',
    appId: '1:723657801401:ios:dc2be6eea227ebcf6d2568',
    messagingSenderId: '723657801401',
    projectId: 'kopimate-470c2',
    storageBucket: 'kopimate-470c2.appspot.com',
    iosClientId:
        '723657801401-ffb7sf6d0nl40q8dgvhdc03snmlp9uec.apps.googleusercontent.com',
    iosBundleId: 'com.example.kopimate',
  );
}
