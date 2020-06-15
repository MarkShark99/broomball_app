import 'package:broomball_app/fragments/ios/conference_fragment_ios.dart';
import 'package:flutter/cupertino.dart';

class MainPageiOS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageiOSState();
  }
}

class MainPageiOSState extends State<MainPageiOS> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections),
            title: Text("Conferences")
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
            title: Text("Teams")
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock),
            title: Text("Schedule")
          )
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
