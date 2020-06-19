import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'logic/login_authProvider.dart';
import 'app_bar_top_instance.dart';
import 'user_account_drawer.dart';
import 'details_page.dart';

final userRepository = UserRepository.instance();

class InstancePage extends StatefulWidget {
  final String instanceName;
  final String instanceId;
  final String instanceCode;

  InstancePage({Key key, this.instanceName, this.instanceId, this.instanceCode})
      : super(key: key);

  @override
  _InstancePageState createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  final picker = ImagePicker();
  openCamera(String host) async {
    FirebaseUser user = Provider.of<UserRepository>(context, listen: false).user;
    var requestCameraPermission = await Permission.camera.request(); // request to use device camera

    final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm().add_s();
    final currentDate = formatter.format(now);



    final imageFile = await picker.getImage(
      //TODO Find proper resolution of pictures
        source: ImageSource.camera, imageQuality: 100); //returns a File after picture is taken
    StorageMetadata metaData = StorageMetadata(customMetadata: <String, String>{
      'author': user.displayName,
      'instanceName': widget.instanceName,
      'host': host
    });

    final StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('$currentDate.jpg');
    final StorageUploadTask uploadTask = storageRef.putFile(
        File(imageFile.path), metaData); // uploads file into Firebase Storage
//    saveFile.writeFile(imageFile.readAsStringSync());

    final StorageTaskSnapshot taskSnapshot = await uploadTask
        .onComplete; // waits for 'uploadTask' to complete then creates a snapshot

    var url = await taskSnapshot.ref
        .getDownloadURL(); // takes the URL of the imageFile

    saveToInstance(url);
    saveAsUserImage(url);
  }

  saveToInstance(String url) {
    final DocumentReference postRef =
        db.document('instances/${widget.instanceId}');
    db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, {
          'photoURL': FieldValue.arrayUnion([url])
        });
      }
    });
  }

  saveAsUserImage(String url) {
    FirebaseUser user = Provider.of<UserRepository>(context, listen: false).user;

    final DocumentReference postRef = db.document('users/${user.uid}');
    db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, {
          'userImages': FieldValue.arrayUnion([url])
        });
      }
    });
  }

  isActive() {
    Future.delayed(const Duration(hours: 2), () {
      print(widget.instanceId);
      DocumentReference docRef = db.document('instances/${widget.instanceId}');
      db.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(docRef);
        if (postSnapshot.exists) {
          print(docRef);
          await tx.update(docRef, {'active': false});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<UserRepository>(context).user;
    isActive(); // instance 'active' should be false in db after 24hours of creation
    return StreamBuilder(
        stream:
            db.collection('instances').document(widget.instanceId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          String instanceName = snapshot.data['instanceName'];
          String host = snapshot.data['host'];
          bool hostCheck = snapshot.data['host'] == user.uid;

          return Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.grey[400],
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: InstanceAppBar(
                    instanceID: widget.instanceId, title: Text(instanceName))),
            drawer: UserAccountDrawer(),
            body: Container(
              height: MediaQuery.of(context).size.height / 1.20,
              child: PhotoGridView(
                docId: widget.instanceId,
                instanceName: widget.instanceName,
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Visibility(
                visible: !user.isAnonymous, //if user is anon don't allow upload.

                child: IconButton(
                  icon: Icon(Icons.camera, color: Colors.deepPurple,),
                  //todo:should be better code to disable splash on button
                  iconSize: 35.0,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => openCamera(host),
                ),
              )),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            );
        });
  }
}

class PhotoGridView extends StatelessWidget {
  final String instanceName;
  final String docId;

  PhotoGridView({this.instanceName, this.docId});

  Stream<List<dynamic>> getPics() {
    DocumentReference docRef = db.collection('instances').document(docId);
    return docRef.snapshots().map((document) {
      List<dynamic> info = document.data['photoURL'].toList();
      return info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getPics(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return Container();
        } else {
          return GridView.builder(
              key: PageStorageKey<String>('Preseves scroll position'),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  crossAxisCount: 2),
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    elevation: 5.0,
                    child: Hero(
                        tag: snapshot.data[index],
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: CachedNetworkImage(imageUrl: snapshot
                              .data[index],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fill),
                        )),
                  ),
                  onTap: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(
                                    id: snapshot.data[index],
                                    imageUrl: snapshot.data[index],
                                    docID: docId,
                                  ))),

                );
              });
        }
      },
    );
  }


  _deleteImage(String name) {
    db.collection('instances').document(docId).updateData(
        {'photoURL': FieldValue.arrayRemove([name])});
    print('I PRESSED IT');
  }
}


