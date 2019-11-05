import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SaveFile {

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

//  Future<String> readImage() async {
//
//    try {
//      final file = await _localFile;
//
//      //read the file.
////      String contents = await file.readAsString();
//     File contents = file.readAsStringSync(file);
////      print(contents);
//      return contents;
//    } catch(e) {
//      print('NOT WORKING');
//      //if empty return null
//      return null;
//    }
//  }
  //  Future<Io.File> getImageFromNetwork(String url) async {

  //    var cacheManager = await CacheManager.getInstance();
  //    Io.File file = await cacheManager.getFile(url);
  //    return file;
  //  }

  //  Future<Io.File> saveImage(String url) async {

  //   final file = await getImageFromNetwork(url);
  //   //retrieve local path for device
  //   var path = await _localPath;
  //   Image image = decodeImage(file.readAsBytesSync());

  //   Image thumbnail = copyResize(image, 120);

  //   // Save the thumbnail as a PNG.
  //   return new Io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')
  //     ..writeAsBytesSync(encodePng(thumbnail));
  // }
}

