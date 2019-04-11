import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'app_bar_bottom.dart';
import 'app_bar_top_instance.dart';
import 'join_create.dart';

class InstancePage extends StatefulWidget {
  final String value;

  InstancePage({Key key, this.value}) : super(key: key);

  @override
  _InstancePageState createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton:
      Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: IconButton(
          icon: Icon(Icons.camera),
          iconSize: 35.0,
          //should be better code to not show splash on button
          splashColor:  Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
          print('press me');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomAppBar(),
    );
  }
  File _image;
  // opens the
  Future<String> openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
}
