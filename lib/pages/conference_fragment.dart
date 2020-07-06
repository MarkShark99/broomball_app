import 'package:broomball_app/pages/division_page.dart';
import 'package:broomball_app/pages/search_fragment.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ConferenceFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConferenceFragmentState();
  }
}

class ConferenceFragmentState extends State<ConferenceFragment>
    with AutomaticKeepAliveClientMixin {
  
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();
  Future<BroomballMainPageData> _broomballData;

  String _currentYear;

  List<String> _yearList = <String>[];

  @override
  bool get wantKeepAlive => true;

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
    return Material(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("Conferences"),
          trailingActions: <Widget>[
            // Center(
            //   child: Text("$_currentYear"),
            // ),
            // IconButton(
            //   icon: Icon(Icons.date_range),
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return SimpleDialog(
            //           title: Text("Select a year"),
            //           children: _yearList.map((year) {
            //             return ListTile(
            //               title: Text(year),
            //               onTap: () {
            //                 Navigator.of(context).pop();
            //                 this.setState(() {
            //                   this._currentYear = year;
            //                   this._broomballData =
            //                       this._broomballWebScraper.run(year);
            //                 });
            //               },
            //             );
            //           }).toList(),
            //         );
            //       },
            //     );
            //   },
            // ),
            PlatformIconButton(
              icon: Icon(context.platformIcons.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchFragment();
                    },
                  ),
                );
              },
            ),
            PlatformIconButton(
              icon: Icon(context.platformIcons.refresh),
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
              if (snapshot.hasData) {
                BroomballMainPageData broomballData = snapshot.data;

                return ListView.separated(
                  itemCount: broomballData.conferences.length,
                  itemBuilder: (context, index) {
                    String text =
                        broomballData.conferences.keys.toList()[index];

                    return ListTile(
                      title: Text(text),
                      onTap: () {
                        Navigator.of(this.context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DivisionPage(
                                conference: broomballData.conferences[text],
                                broomballData: broomballData,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                );
              } else {
                return PlatformCircularProgressIndicator();
              }
            },
            future: _broomballData,
          ),
        ),
      ),
    );
  }
}
