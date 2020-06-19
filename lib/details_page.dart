import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as Image;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flushbar/flushbar.dart';

import 'logic/login_authProvider.dart';

class DetailsPage extends StatefulWidget {
  final String imageUrl;
  final String id;
  final String docID;


  DetailsPage({this.imageUrl, this.id, this.docID});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {

    FirebaseUser user = Provider.of<UserRepository>(context).user;
    return FutureBuilder(
        future: getMetaData(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            StorageMetadata storageMetadata = snapshot.data;
            String when = timeago.format(DateTime.fromMillisecondsSinceEpoch(
                    storageMetadata.creationTimeMillis)
                .toLocal());
            String imageName = storageMetadata.name;
            String name = storageMetadata.customMetadata['author'];
            String instanceName =
                storageMetadata.customMetadata['instanceName'];
            String host = storageMetadata.customMetadata['host'];

            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton: Visibility(
                visible: visible,
                child: Builder(
                  builder: (context) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          child: Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Flushbar(
                              backgroundColor: Colors.deepPurple,
                              messageText: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('From $instanceName',
                                      style: TextStyle(color: Colors.white)),
                                  Text('$when',
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                              duration: Duration(seconds: 2),
                            )..show(context);
                          }),
                      Visibility(
                        visible: name == user.displayName ||
                            host ==
                                user.uid, // if user took photo then show delete button
                        child: FlatButton(
                            child: Icon(
                              FontAwesomeIcons.trash,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              deleteInsideInstance(widget.docID, user.uid);
                              deleteImageFromGallery(user.uid);
                              Navigator.pop(context);
                            }),
                      ),
                      Visibility(
                        visible: !user
                            .isAnonymous, //if user is not anonymous allow download.
                        child: FlatButton(
                          child: Icon(FontAwesomeIcons.download,
                              color: Colors.white),
                          onPressed: () => _downloadImage(imageName),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: GestureDetector(
                //Pop back to page on vertical dragdown
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta > 3.5) {
                    Navigator.pop(context);
                  }
                },
                child: Hero(
                  tag: widget.id,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.fill, //TODO:might have to fix test needed
                    height: MediaQuery.of(context)
                        .size
                        .height, //TODO://might have to fix test needed
                    width: MediaQuery.of(context)
                        .size
                        .width, //TODO://might have to fix test needed
                  ),
                ),
                onTap: () {
                  setState(() {
                    visible = !visible;
                  });

                },
              ),
            );
          }
        });
  }

  getMetaData() async {
    StorageReference storageRef =
        await FirebaseStorage.instance.getReferenceFromUrl(widget.imageUrl);
    String imageName = await storageRef.getName();
    StorageMetadata storageMetadata = await FirebaseStorage.instance
        .ref()
        .child('images/$imageName')
        .getMetadata();
    return storageMetadata;
  }

  Widget detailsDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            subtitle: Text('subtitle'),
//            leading: Text('PhotoInfo'),
            title: Text('hello'),
          )
        ],
      ),
    );
  }

  _downloadImage(String imageName) async {
//    var requestStoragePermission = await PermissionHandler().requestPermissions([PermissionGroup.storage]); //request allow write to external storage.

    var imageFile = await DefaultCacheManager().getSingleFile(widget.imageUrl);
    Image.Image image = Image.decodeImage(imageFile.readAsBytesSync());
    Image.Image thumbnail = Image.copyResize(image,
        width: 200,
        height:
            200); //find use for it instead of downloading the full image download small scale
    bool checkIfExists =
        await File('storage/emulated/0/ISSTH/$imageName').exists();
    File savedImage = File('storage/emulated/0/ISSTH/$imageName')
      ..writeAsBytesSync(Image.encodeJpg(image));

    if (checkIfExists) {
      print('already saved');
      return null;
    } else {
      print('Saving.');
      return savedImage;
    }
  }

  deleteInsideInstance(String docID, String user) async {
    //
    StorageReference storageRef = await FirebaseStorage.instance
        .getReferenceFromUrl(widget.imageUrl); // references Image to FirebaseStorage

    final DocumentReference instRef = db.document('instances/$docID');
    final DocumentReference userRef = db.document('users/$user');

    db.runTransaction((Transaction tx) async {
      await tx.update(instRef, {
        'photoURL': FieldValue.arrayRemove([widget.imageUrl])
      }); //removes from instance collection
    });
//    storageRef.delete(); // will delete the Image from Firebase Storage. No longer exists
  }

  deleteImageFromGallery(String user) async {
    final DocumentReference userRef = db.document('users/$user');

    db.runTransaction((Transaction tx) async {
      await tx.update(userRef, {
        'userImages': FieldValue.arrayRemove([widget.imageUrl])
      }); //removes from user collection but not instance
    });
  }
}
