import 'dart:io';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:path_provider/path_provider.dart';

class AppData {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/favorites.json');
  }

  Future<File> writePlayerData(Player playerData) async {
    final file = await _localFile;

    return file.writeAsString('$playerData');
  }
}
