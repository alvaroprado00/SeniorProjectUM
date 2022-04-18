import 'package:firebase_messaging/firebase_messaging.dart';

class MessageController {

  static getToken() {
    return FirebaseMessaging.instance.getToken().toString();
  }


}