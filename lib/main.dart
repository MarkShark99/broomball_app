import 'package:broomball_app/pages/android/main_page_android.dart';
import 'package:broomball_app/pages/ios/main_page_ios.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() => runApp(BroomballApp());

class BroomballApp extends StatelessWidget {
  final String appTitle = "Broomball App";

  @override
  Widget build(BuildContext context) {
    // BroomballNotification.init();

    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) {
        return ThemeData(
          primaryColor: brightness == Brightness.light
              ? Color(0xFFFFCD00)
              : Color(0xFF008197),
          accentColor: brightness == Brightness.light
              ? Color(0xFFFFCD00)
              : Color(0xFF008197),
          brightness: brightness,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        );
      },
      themedWidgetBuilder: (context, theme) {
        switch (Theme.of(context).platform) {
          case TargetPlatform.android:
            return new MaterialApp(
              title: appTitle,
              theme: theme,
              home: MainPageAndroid(),
              debugShowCheckedModeBanner: false,
            );
            break;
          case TargetPlatform.iOS:
          return CupertinoApp(
            title: appTitle,
            home: MainPageiOS(),
            debugShowCheckedModeBanner: false,
          );
            break;
          default:
            break;
        }
      },
    );
  }
}
