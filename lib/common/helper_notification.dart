import 'dart:convert';

import 'package:chat_flutter/common/routes/routes.dart';
import 'package:chat_flutter/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class HelperNotifications {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS,
      // linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
        var data = jsonDecode(payload);
        if (data['screen'] == 'chat') {
          Get.toNamed(AppRoutes.Message, parameters: {
            "doc_id": data['doc_id'],
            "to_uid": data['to_uid'],
            "to_name": data['to_name'],
            "to_avatar": data['to_avatar'],
            "from_uid": data['from_uid'],
            "from_name": data['from_name'],
            "from_avatar": data['from_avatar'],
          });
        }
      }
      // selectedNotificationPayload = payload;
      // selectNotificationSubject.add(payload);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".................OnMessage.................");
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}/${message.data}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification?.body ?? '',
        htmlFormatBigText: true,
        contentTitle: message.notification?.title ?? '',
        htmlFormatContentTitle: true,
        // summaryText: message.notification?.title ?? '',
        htmlFormatSummaryText: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'chat_flutter',
        'chat_flutter',
        channelDescription: 'fcm chat flutter',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
      );

      IOSNotificationDetails iOSPlatformChannelSpecifics =
          const IOSNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['data'],
      );
    });
  }
}
