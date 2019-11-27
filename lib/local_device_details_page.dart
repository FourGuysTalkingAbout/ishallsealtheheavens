import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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
            fit: isPortrait ? BoxFit.cover : BoxFit.fill,
          ),
        ),
      ),
      floatingActionButton: Row(
        children: <Widget>[
          FlatButton(
            child: Icon(FontAwesomeIcons.trash, color: Colors.white),
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
