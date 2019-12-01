import 'package:broomball_app/pages/division_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class ConferenceFragment extends StatefulWidget {
  final String year;

  ConferenceFragment({@required this.year});

  @override
  State<StatefulWidget> createState() {
    return ConferenceFragmentState();
  }
}

class ConferenceFragmentState extends State<ConferenceFragment> {
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();
  Future<BroomballData> _broomballData;

  @override
  void initState() {
    super.initState();
    _broomballData = _broomballWebScraper.run(widget.year);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              BroomballData broomballData = snapshot.data;

              return ListView.separated(
                itemCount: broomballData.conferences.length,
                itemBuilder: (context, index) {
                  String text = broomballData.conferences.keys.toList()[index];

                  return ListTile(
                    title: Text(text),
                    onTap: () {
                      Navigator.of(this.context).push(MaterialPageRoute(
                        builder: (context) {
                          return DivisionPage(
                            conference: broomballData.conferences[text],
                            broomballData: broomballData,
                          );
                        },
                      ));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
          }
          return null;
        },
        future: _broomballData,
      ),
    );
  }
}
