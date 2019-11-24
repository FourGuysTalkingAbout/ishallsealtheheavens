import 'dart:io';
import 'package:flutter/material.dart';


class DeviceImage extends StatelessWidget {
   final File file;

  const DeviceImage({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var check = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Center(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          child: Image.file(file,
            fit: isPortrait ? BoxFit.fill : BoxFit.cover,
          ),
        ),
      ),
      floatingActionButton: Row(
        children: <Widget>[
          FlatButton(
            child: Icon(Icons.delete),
            onPressed: () {
              deleteImage();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  deleteImage() { //deletes the file from device
    file.delete();
  }
}
