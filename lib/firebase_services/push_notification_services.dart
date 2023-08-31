import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
Future<void> backgroundHandler(RemoteMessage message) async{
  log("message received! ${message.notification!.title}");
}
class NotificationService{
  static Future<void> initialize() async{
    NotificationSettings settings= await FirebaseMessaging.instance.requestPermission();
    if(settings.authorizationStatus ==AuthorizationStatus.authorized){
      ///get the token to send notification through postman
     String? token = await FirebaseMessaging.instance.getToken();
     if(token!=null){
       log(token);
     }
      ///Sends the notification background message to the app
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      log("Notification Initialized!");
    }
  }
}
