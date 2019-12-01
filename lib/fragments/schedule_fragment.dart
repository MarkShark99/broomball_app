import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class ScheduleFragment extends StatefulWidget {
  final String year;

  ScheduleFragment({this.year});

  @override
  State<StatefulWidget> createState() {
    return ScheduleFragmentState();
  }
}

class ScheduleFragmentState extends State<ScheduleFragment> {
  BroomballWebScraper _broomballWebScraper = BroomballWebScraper();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              return Text("Loaded");
          }
        },
        future: _broomballWebScraper.run(widget.year),
      ),
    );
  }
}
