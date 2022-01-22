import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase.dart';

class FirebaseHelper  {
  static fb.Database initDatabase() {
    try {
      if (fb.apps.isEmpty) {
        fb.initializeApp(
            apiKey: "AIzaSyCh9Usz9IMgYkB_L9SlV3m16mc5RBrOscc",
            authDomain: "helps-28f27.firebaseapp.com",
            databaseURL: "https://helps-28f27.firebaseio.com",
            projectId: "helps-28f27",
            storageBucket: "helps-28f27.appspot.com",
            messagingSenderId: "39756628611",
            appId: "1:39756628611:web:f51c3f208882e6e43511b6",
            measurementId: "G-8TFLGL1NJ1"
        );
      }
    } on fb.FirebaseJsNotLoadedException catch (e) {
      print(e);
    }
    return fb.database();
  }
}

class fire{
  static fb.Database database = FirebaseHelper.initDatabase();
}