import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      // case TargetPlatform.windows:
      //   return web;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyA_PPxVS1Xj5QuxkGybsFTG7ZUuiU0usu8",
    authDomain: "https://mauhurtika-pre-default-rtdb.firebaseio.com",
    projectId: "mauhurtika-pre",
    storageBucket: "mauhurtika-pre.appspot.com",
    messagingSenderId: "381086206621", //381086206621
    appId: "1:948854405434:android:0be0bda84ebb3e64513803",
    measurementId: "G-KBPRBBZRYC",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyA_PPxVS1Xj5QuxkGybsFTG7ZUuiU0usu8",
    appId: "1:948854405434:android:0be0bda84ebb3e64513803",
    messagingSenderId: "948854405434",
    projectId: "mauhurtika-pre",
    storageBucket: "mauhurtika-pre.appspot.com",
    iosBundleId: 'com.mauhurtika.astrologyapp',
    measurementId: "G-KBPRBBZRYC",
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyA_PPxVS1Xj5QuxkGybsFTG7ZUuiU0usu8",
      authDomain: "astroway-diploy.firebaseapp.com",
      databaseURL: "https://mauhurtika-pre-default-rtdb.firebaseio.com",
      projectId: "mauhurtika-pre",
      storageBucket: "mauhurtika-pre.appspot.com",
      messagingSenderId: "948854405434",
      appId: "1:948854405434:android:0be0bda84ebb3e64513803",
      measurementId: "G-XY1LD81J6X");
}
