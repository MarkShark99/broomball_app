import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BroomballNotification {
  static void init() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      // var initializationSettingsAndroid =
          // new AndroidInitializationSettings('app_icon');
      // var initializationSettings = InitializationSettings(initializationSettingsAndroid, null);
      // flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }
  static Future onSelectNotification(String payload) async {
    //if (payload != null) {
    //  debugPrint('notification payload: ' + payload);
    //}
    //await 
    print("Pressed");
  }
}