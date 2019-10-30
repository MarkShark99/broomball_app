import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class TeamsFragment extends StatefulWidget {
  final String year;

  TeamsFragment({this.year});

  @override
  State<StatefulWidget> createState() {
    return TeamsFragmentState();
  }
}

class TeamsFragmentState extends State<TeamsFragment> {
  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: broomballData.jsonData["teams"].keys.toList().length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    broomballData.jsonData["teams"][broomballData.jsonData["teams"].keys.toList()[index].toString()]["teamName"],
                  ),
                  onTap: () {

                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }
}
