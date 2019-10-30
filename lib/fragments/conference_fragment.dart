import 'package:broomball_app/pages/division_page.dart';
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
                    String selection = broomballData.jsonData["years"][widget.year]["conferences"].keys.toList()[index];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DivisionPage(selection, widget.year)));
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
