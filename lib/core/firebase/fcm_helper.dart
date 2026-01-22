import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'package:smart_finger/core/shared_prefs_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 🔔 Local notification init
Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification clicked: ${response.payload}");
    },
  );
}

class FcmHelper {
  final int technicianId;

  FcmHelper({required this.technicianId});

  // 🔐 Notification permission handler (Android 13+)
  static Future<void> handleNotificationPermission() async {
    if (!Platform.isAndroid) return;

    final settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    // ✅ First time → show dialog
    if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      final result =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print(
          "Notification permission result => ${result.authorizationStatus}");
      return;
    }

    // ❌ Denied → open app settings
    if (settings.authorizationStatus ==
        AuthorizationStatus.denied) {
      await openAppSettings();
    }
  }

  /// 🚀 Init FCM
  Future<void> initFCM() async {
    // 🔹 Ask notification permission safely
    await handleNotificationPermission();

    // 🔹 Local notification setup
    await initLocalNotifications();

    // 🔹 Get FCM token
    final String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      print("FCM Token => $token");
      await sendTokenToBackend(token);
    }

    // 🔹 Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Foreground message received");

      if (message.notification != null) {
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'default_channel',
          'Smart Finger Notifications',
          channelDescription: 'Technician alerts',
          importance: Importance.max,
          priority: Priority.high,
        );

        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidDetails);

        await flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: message.data['payload'] ?? '',
        );
      }
    });

    // 🔹 When notification opens app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification tapped");
    });
  }

  /// 🔗 Send token to backend
  Future<void> sendTokenToBackend(String token) async {
    final authToken = await SharedPrefsHelper.getToken();

    final url =
        Uri.parse("https://sfadmin.in/app/technician/auth/save-fcm.php");

    final body = jsonEncode({
      "technician_id": technicianId,
      "fcm_token": token,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: body,
      );

      print("FCM token saved => ${response.body}");
    } catch (e) {
      print("FCM token error => $e");
    }
  }
}


