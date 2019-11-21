import 'package:flutter/material.dart';

class ScheduleFragment extends StatefulWidget {
  final String year;

  ScheduleFragment({this.year});

  @override
  State<StatefulWidget> createState() {
    return ScheduleFragmentState();
  }
}

class ScheduleFragmentState extends State<ScheduleFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.year != null) {
      return DefaultTabController(
        length: 3,
        child: Center(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
