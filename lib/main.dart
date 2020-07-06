import 'package:broomball_app/pages/main_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
        return PlatformApp(
          android: (context) => MaterialAppData(theme: DynamicTheme.of(context).data),
          home: MainPage(),
        );
      },
    );
  }
}
