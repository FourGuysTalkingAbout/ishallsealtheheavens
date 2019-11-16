import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flushbar/flushbar.dart';

import 'logic/login_authProvider.dart';

class DetailsPage extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String docID;

  DetailsPage({this.imageUrl, this.id, this.docID});

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

            String name = storageMetadata.customMetadata['author'];
            String instanceName = storageMetadata.customMetadata['instanceName'];
            return Scaffold(
//              endDrawer: detailsDrawer(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton: Builder(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      visible: name == user.displayName, // if user took photo then show delete button
                      child: FlatButton(
                          child: Icon(FontAwesomeIcons.trash,color: Colors.white,),
                          onPressed: () {
                            deleteInsideInstance(docID, user.uid);
                            deleteImageFromGallery(user.uid);
                            Navigator.pop(context);
                          }
                      ),
                    )
                  ],
                ),
              ),
              body: GestureDetector(
                child: Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
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
//
                  Navigator.pop(context);
                },
              ),
            );
          }
        });
  }

  getMetaData() async {
    StorageReference storageRef = await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
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

  // find way to access
  deleteInsideInstance(String docID, String user) async { //
    StorageReference storageRef = await FirebaseStorage.instance.getReferenceFromUrl(imageUrl); // references Image to FirebaseStorage

    final DocumentReference instRef = db.document('instances/$docID');
    final DocumentReference userRef = db.document('users/$user');

    db.runTransaction((Transaction tx) async {
       await tx.update(instRef,  {'photoURL': FieldValue.arrayRemove([imageUrl])}); //removes from instance collection

    });
//    storageRef.delete(); // will delete the Image from Firebase Storage. No longer exists
  }

  deleteImageFromGallery(String user) async {
    final DocumentReference userRef = db.document('users/$user');

    db.runTransaction((Transaction tx) async {
      await tx.update(userRef,  {'userImages': FieldValue.arrayRemove([imageUrl])}); //removes from user collection but not instance
    });
  }
}
