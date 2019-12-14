import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BroomballNotifications {
  static final BroomballNotifications _instance = BroomballNotifications._internal();
  BuildContext _context;

  factory BroomballNotifications(BuildContext context) {
    _instance._context = context;
    

    return _instance;
  }

  BroomballNotifications._internal();

  Future onSelectNotification(String payload) async {
    Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (context) {
          return TeamPage(id: payload);
        },
      ),
    );
  }


}
