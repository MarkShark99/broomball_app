import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final String year;

  SchedulePage({this.year});

  @override
  State<StatefulWidget> createState() {
    return SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return CircularProgressIndicator();
              case ConnectionState.done:
                return Text("Loaded");
            }
          },
          future: null,
        ),
      ),
    );
  }
}
