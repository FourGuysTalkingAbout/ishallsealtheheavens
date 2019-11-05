import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SaveFile {
  //TODO:FIND WAY TO SAVE A NETWORK URL TO DEVICE
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
//    print(path);
    return File('$path/image1.png');
  }

  Future<File> writeImage(File file) async {
    final filePath = await _localFile;

    print('WRITING FILE');
    return  filePath.writeAsString('$file');
  }
}

