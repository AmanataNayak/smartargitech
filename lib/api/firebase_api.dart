import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iot_app/main.dart';
import 'package:iot_app/pages/homePage.dart';


class FirebaseAPI{
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for notification',
    importance: Importance.defaultImportance
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();



  void handleMessage(RemoteMessage? message){
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      MyHomePage.route,
      arguments: message
    );
  }

  Future initLocalNotifications() async{
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const setting = InitializationSettings(android: android);

    await _localNotifications.initialize(
      setting,
      onDidReceiveNotificationResponse: (payload){
        final message = RemoteMessage.fromMap(jsonDecode(payload as String));
        handleMessage(message);
      }
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);

  }
 
  Future initPushNotification() async{
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

      FirebaseMessaging.onMessage.listen((message){
        final notification = message.notification;
        if(notification==null) return;
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap(),)
        );
      });
  }
  Future<void> initNotification() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    initPushNotification();
    initLocalNotifications();
  }
}