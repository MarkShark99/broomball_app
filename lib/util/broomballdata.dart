import 'dart:convert';

import 'package:http/http.dart';

class BroomballData {
  final String url =
      "https://classdb.it.mtu.edu/cs3141/BroomballApp/output.json";

  Map jsonData;

  static final BroomballData _instance = BroomballData._internal();

  factory BroomballData() {
    return _instance;
  }

  BroomballData._internal();

  Future<void> fetch() async {
    final Response response = await get(url);

    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }
}
