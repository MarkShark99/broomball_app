import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class ConferenceFragment extends StatefulWidget {
  final String year;

  ConferenceFragment(year) : this.year = year;

  @override
  State<StatefulWidget> createState() {
    return ConferenceFragmentState();
  }
}

class ConferenceFragmentState extends State<ConferenceFragment> {
  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    print(widget.year);
    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: broomballData
                  .jsonData["years"][widget.year]["conferences"].keys
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(broomballData
                  .jsonData["years"][widget.year]["conferences"].keys.toList()[index]),
                  onTap: () {},
                );
              },
            ),
    );
  }
}
