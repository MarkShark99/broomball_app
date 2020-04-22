import 'package:broomball_app/fragments/android/search_fragment_android.dart';
import 'package:broomball_app/pages/division_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class ConferenceFragment extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return ConferenceFragmentState();
  }
}

class ConferenceFragmentState extends State<ConferenceFragment> {
  
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();
  Future<BroomballMainPageData> _broomballData;

  String _currentYear;

  List<String> _yearList = <String>[];  
  
  @override
  void initState() {
    super.initState();
    int yearOffset = DateTime.now().month == 12 ? 1 : 0;
    int currentYear = DateTime.now().year + yearOffset;
    _yearList = <String>[];

    for (int i = currentYear; i >= 2002; i--) {
      _yearList.add(i.toString());
    }

    _currentYear = currentYear.toString();
    _broomballData = _broomballWebScraper.run(_currentYear);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conferences"),
        actions: <Widget>[
          Center(
            child: Text("$_currentYear"),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("Select a year"),
                    children: _yearList.map((year) {
                      return ListTile(
                        title: Text(year),
                        onTap: () {
                          Navigator.of(context).pop();
                          this.setState(() {
                            this._currentYear = year;
                            this._broomballData =
                                this._broomballWebScraper.run(year);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SearchFragmentAndroid();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              this.setState(() {
                _broomballData = _broomballWebScraper.run(this._currentYear);
              });
            },
          ),
        ],
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
              BroomballMainPageData broomballData = snapshot.data;

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
    )
    );
    
  }
}
