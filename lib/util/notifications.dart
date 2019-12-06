import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class BroomballNotification {
  static final BroomballNotification _instance = BroomballNotification._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationDetails androidPlatformChannelSpecifics;
  NotificationDetails platformChannelSpecifics;

  void initNotifications() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, null);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  void initDisplay(){

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics, null);

  }

  factory BroomballNotification() {
    return _instance;
  }

  BroomballNotification._internal();

  Future onSelectNotification(String payload) async {
    // {
    // Navigator.of(context).push(MaterialPageRoute(
    // builder: (context) {
    // return PlayerPage(id: id);
    //},
    // ));
    // }
    print("Pressed");
  }

  Future convertScheduleNotification(String matchTime) async {



  }

}