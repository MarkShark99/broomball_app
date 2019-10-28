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
  
  @override
  Widget build(BuildContext context) {
    print(widget.year);
    return Center(
      child: widget.year == null ? CircularProgressIndicator() : Text(widget.year),
    );
  }
}
