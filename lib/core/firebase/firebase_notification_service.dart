import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_finger/core/firebase/app_navigator.dart';
import 'package:smart_finger/core/firebase/notification_screen.dart';

class FirebaseNotificationService {
  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// 🔔 Foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _openNotificationScreen(message);
    });

    /// 🔔 App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _openNotificationScreen(message);
    });

    /// 🔔 App launched by notification (not terminated, but cold start)
    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _openNotificationScreen(initialMessage);
    }

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("🔥 FCM TOKEN: $token");
  }

  static void _openNotificationScreen(RemoteMessage message) {
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => NotificationScreen(
          title: message.notification?.title ?? 'New Complaint',
          message: message.notification?.body ?? '',
          complaintId: message.data['complaint_id'],
        ),
      ),
    );
  }
}

/// 🔴 REQUIRED for background delivery
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
}
