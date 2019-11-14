import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flushbar/flushbar.dart';

import 'logic/login_authProvider.dart';

class DetailsPage extends StatelessWidget {
  final String imageUrl;
  final String id;

  DetailsPage({this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    getMetaData() async {
      StorageReference storageRef =
          await FirebaseStorage.instance.getReferenceFromUrl(imageUrl);
      String hello = await storageRef.getName();
      StorageMetadata storageMetadata = await FirebaseStorage.instance
          .ref()
          .child('images/$hello')
          .getMetadata();
      return storageMetadata;
    }

    return FutureBuilder(
        future: getMetaData(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            StorageMetadata storageMetadata = snapshot.data;
            String when = timeago.format(DateTime.fromMillisecondsSinceEpoch(
                    storageMetadata.creationTimeMillis)
                .toLocal());
            print(DateTime.fromMillisecondsSinceEpoch(
                    storageMetadata.creationTimeMillis)
                .toLocal());
            String name = storageMetadata.customMetadata['author'];
            String instanceName =
                storageMetadata.customMetadata['instanceName'];
            return Scaffold(
              endDrawer: detailsDrawer(),
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
                    FlatButton(
                        child: Icon(Icons.delete),
                        onPressed: () => print('delete')),
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
                  Navigator.pop(context);
                },
              ),
            );
          }
        });
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

  deleteData() {
    //TODO FIX DELETE FUNCTION.
    db
        .collection('instances')
        .document('instance1')
        .collection('photos')
        .document(id)
        .delete(); //TODO: ONLY DELETES IN DATABASE NOT STORAGE
  }
}
