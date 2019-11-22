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
  final BroomballAPI _broomballAPI = BroomballAPI();
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();

  List<String> _conferenceList = <String>[];

  @override
  void initState() {
    super.initState();
    print("Created conference fragment");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.year != null) {
      
      _updateConferenceList();
    }

    if (_conferenceList.length == 0) {
      print("Empty conference list");
    }

    return Center(
      child: _conferenceList.length == 0
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: _conferenceList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_conferenceList[index]),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return DivisionPage(selectedConference: _conferenceList[index], year: widget.year);
                      },
                    ));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }

  void _updateConferenceList() {
    print("Updating conference list");
    List<String> conferenceList = <String>[];
    _broomballWebScraper.run(widget.year).then((broomballData) {
      for (String conference in broomballData.conferences.keys.toList()) {
        conferenceList.add(conference);
      }
      conferenceList.sort();
      _conferenceList = conferenceList;
    });
  }
}
