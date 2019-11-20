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

  List<String> _conferenceList = <String>[];

  @override
  Widget build(BuildContext context) {
    if (widget.year != null) {
      _conferenceList = _getConferenceList();
    }

    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: _conferenceList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_conferenceList[index]),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DivisionPage(selectedConference: _conferenceList[index], year: widget.year)));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }

  List<String> _getConferenceList() {
    List<String> conferenceList = <String>[];

    for (String conference in broomballData.jsonData["years"][widget.year]["conferences"].keys.toList()) {
      conferenceList.add(conference);
    }

    conferenceList.sort();

    return conferenceList;
  }
}
