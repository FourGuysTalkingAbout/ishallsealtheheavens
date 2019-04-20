import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishallsealtheheavens/app_bar_top.dart';
import 'app_bar_bottom.dart';
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
      endDrawer: drawerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: IconButton(
          icon: Icon(Icons.camera),
          iconSize: 35.0,
          //todo:should be better code to disable splash on button
          splashColor:  Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () =>  openCamera(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomAppBar(),
    );
  }

  Future openCamera() async {

    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    //todo:figure out a way to name images
    //'images' is folder in firebase, '123451' is name of the file
  final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('images').child('123451');

  final StorageUploadTask uploadTask = storageRef.putFile(image);

  }
}
