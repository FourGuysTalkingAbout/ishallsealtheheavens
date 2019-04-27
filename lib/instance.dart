import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_bar_top_instance.dart';
import 'app_bar_bottom.dart';

class InstancePage extends StatefulWidget {
  final String value; //TODO: is this needed?

  InstancePage({Key key, this.value}) : super(key: key);

  @override
  _InstancePageState createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  final db = Firestore.instance;

  openCamera() async {
    //TODO: implement a better naming convention for the 'imageName'
    final String imageName = '${Random().nextInt(100)}';

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera); //returns a File after picture is taken

    //'images' is a folder in Firebase Storage,
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('images').child('$imageName');

    final StorageUploadTask uploadTask =
        storageRef.putFile(imageFile); // uploads file into Firebase Storage

    final StorageTaskSnapshot taskSnapshot = await uploadTask
        .onComplete; // waits for 'uploadTask' to complete then creates a snapshot

    var url = await taskSnapshot.ref
        .getDownloadURL(); // takes the URL of the imageFile

    DocumentReference DocRef = await db
        .collection('instances')
        .document('instance1')
        .collection('photos')
        .add({'url': url});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: InstanceTopAppBar(),
      endDrawer: DrawerMenu(),
      body: Center(
        child: Column(
          children: <Widget>[
            InstanceSecondAppBar(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: IconButton(
          icon: Icon(Icons.camera),
          iconSize: 35.0,
          //todo:should be better code to disable splash on button
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => openCamera(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomAppBar(),
    );
  }
}
