import 'package:flutter/cupertino.dart';

class ConferenceFragmentIOS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConferenceFragmentIOSState();
  }
}

class ConferenceFragmentIOSState extends State<ConferenceFragmentIOS> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Conferences"),
      ),
      child: Center(child: Text("Conferences"),)
    );
  }
}
