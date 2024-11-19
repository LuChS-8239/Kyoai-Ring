import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);}


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
    apiKey: 'AIzaSyCYzZMWR99hLpenH7Q8NLXtCoTV4CqEsfI',
    appId: '1:481237379007:web:5e8443d7a139cd48bfa30a',
    messagingSenderId: '481237379007',
    projectId: 'kyoai-ring',
    authDomain: 'kyoai-ring.firebaseapp.com',
    databaseURL: 'https://kyoai-ring-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kyoai-ring.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBL9s6FbmaMzKIkqtVEUa8JPm2RVb5f2EQ',
    appId: '1:481237379007:android:189dd4f52c99bdbabfa30a',
    messagingSenderId: '481237379007',
    projectId: 'kyoai-ring',
    databaseURL: 'https://kyoai-ring-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kyoai-ring.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZT1d1lCvc0w_bE4HylrjEoOndoxA24ZI',
    appId: '1:481237379007:ios:6b97e344e6b458a3bfa30a',
    messagingSenderId: '481237379007',
    projectId: 'kyoai-ring',
    databaseURL: 'https://kyoai-ring-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kyoai-ring.appspot.com',
    iosBundleId: 'com.example.test',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZT1d1lCvc0w_bE4HylrjEoOndoxA24ZI',
    appId: '1:481237379007:ios:6b97e344e6b458a3bfa30a',
    messagingSenderId: '481237379007',
    projectId: 'kyoai-ring',
    databaseURL: 'https://kyoai-ring-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kyoai-ring.appspot.com',
    iosBundleId: 'com.example.test',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYzZMWR99hLpenH7Q8NLXtCoTV4CqEsfI',
    appId: '1:481237379007:web:d0124f20bc65523cbfa30a',
    messagingSenderId: '481237379007',
    projectId: 'kyoai-ring',
    authDomain: 'kyoai-ring.firebaseapp.com',
    databaseURL: 'https://kyoai-ring-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'kyoai-ring.appspot.com',
  );
}