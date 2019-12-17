import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BroomballNotifications {
  static final BroomballNotifications _instance = BroomballNotifications._internal();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  BuildContext _context;

  factory BroomballNotifications() {
    return _instance;
  }

  BroomballNotifications._internal() {
    print("Initializing notifications");
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@drawable/ic_notification_icon");
    InitializationSettings initializationSettings = InitializationSettings(androidInitializationSettings, null);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: null);
  }

  Future onSelectNotification(String payload) async {
    if (_context == null) {
      return null;
    }

    Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (context) {
          return TeamPage(
            id: payload,
          );
        },
      ),
    );
  }

  void scheduleNotification(String id, DateTime dateTime, String teamVsTeam) async {
    // print("Scheduling notification");
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("Broomball", "Broomball", "Broomball");

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, null);
    await _flutterLocalNotificationsPlugin.schedule(int.parse(id), "A broomball match is starting soon!", teamVsTeam, dateTime.subtract(Duration(minutes: 0)), notificationDetails, androidAllowWhileIdle: true);

    // print("Notification scheduled");
  }

  void cancelNotificationsById(String id) async {
    await _flutterLocalNotificationsPlugin.cancel(int.parse(id));
  }
}
