

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/Page/notification.dart';
import 'package:notifications/main.dart';



class FirebaseApi{
  
 Future<void> initNotification() async {
  await FirebaseMessaging.instance.requestPermission();
  final String? fcmToken = await FirebaseMessaging.instance.getToken();
   
  print('Fcm token >>> $fcmToken');
 
 initPushNotifications();
 initLocalNotifications();
 
}
  
}

void handleMessage(RemoteMessage? message){
  if(message==null)return;
  navigatorKey.currentState?.pushNamed(Notifications.route,arguments: message, );
}
final firebase_Messaging  = FirebaseMessaging.instance;

 final _androidChannel = const AndroidNotificationChannel('high_importance_channel', 'High importance notification',
 description: 'foreground notificaion description', importance: Importance.defaultImportance);


 

Future initPushNotifications ()async{
   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true, 
   );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) { 
      final notification= message.notification; 
      final _localNotifications = FlutterLocalNotificationsPlugin();
if(notification == null)return; 


 
 _localNotifications.show(notification.hashCode,notification.title, notification.body, NotificationDetails(
  android: AndroidNotificationDetails(_androidChannel.id, _androidChannel.name, channelDescription: _androidChannel.description,
   icon: '@drawable/ic_launcher',  ),
  
 ),
 payload: jsonEncode(message.toMap()),
 );
    });
}


Future initLocalNotifications()async{
  const IOS = DarwinInitializationSettings();
  const Android =AndroidInitializationSettings('@drawable/ic_launcher');
  const Settings = InitializationSettings(android: Android,iOS: IOS); 
 
 final _localNotifications = FlutterLocalNotificationsPlugin();
  
  await _localNotifications.initialize(Settings, onDidReceiveNotificationResponse: (payload){
   final message  = RemoteMessage.fromMap(jsonDecode(payload.payload!));
   handleMessage(message);
  });
final _localnotifications = FlutterLocalNotificationsPlugin(); 

  await _localnotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(_androidChannel);
}

 
Future<void> handleBackgroundMessage(RemoteMessage message)async{
  print('Title ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
    print('PayLoad: ${message.data}');
  
}

