import 'package:broomball_app/pages/division_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class ConferenceFragment extends StatefulWidget {
  final String year;

  ConferenceFragment({this.year});

  @override
  State<StatefulWidget> createState() {
    return ConferenceFragmentState();
  }
}

class ConferenceFragmentState extends State<ConferenceFragment> {
  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    //print(widget.year);
    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: broomballData
                  .jsonData["years"][widget.year]["conferences"].keys
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(broomballData
                      .jsonData["years"][widget.year]["conferences"].keys
                      .toList()[index]),
                  onTap: () {
                    String selectedConference = broomballData
                        .jsonData["years"][widget.year]["conferences"].keys
                        .toList()[index];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DivisionPage(
                                selectedConference: selectedConference,
                                year: widget.year)));
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
