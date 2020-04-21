import 'package:broomball_app/fragments/ios/conference_fragment_ios.dart';
import 'package:flutter/cupertino.dart';

class MainPageIOS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageIOSState();
  }
}

class MainPageIOSState extends State<MainPageIOS> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return ConferenceFragmentIOS();
            break;
          case 1:
          break;
          case 2:
          break;
          case 3:
          break;
          default:
          break;
        }
      },
    );
  }
}
