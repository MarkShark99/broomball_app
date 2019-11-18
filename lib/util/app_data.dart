import 'dart:convert';
import 'dart:io';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:path_provider/path_provider.dart';

class AppData {

  Map favoritesData;

  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/favorites.json');
  }

  Future<void> writePlayerData(Player playerData) async {
    final file = await _localFile;

    file.writeAsString(jsonEncode('$playerData'));
  }

  Future<void> readPlayerData() async {
    final file = await _localFile;

    String response = await file.readAsString();

    favoritesData = jsonDecode(response);

  }
}
