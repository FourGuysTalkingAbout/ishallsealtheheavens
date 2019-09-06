import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_bar_top_instance.dart';
import 'app_bar_bottom.dart';
import 'user_account_drawer.dart';

import 'package:intl/intl.dart';

final db = Firestore.instance;

class InstancePage extends StatefulWidget {
  final String value; //TODO: is this needed?

  InstancePage({Key key, this.value}) : super(key: key);

  @override
  _InstancePageState createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  openCamera() async {
    //TODO: implement a better naming convention for the 'imageName'
//    final String imageName = '${Random().nextInt(100)}';
    final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera); //returns a File after picture is taken

    //'images' is a folder in Firebase Storage,
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('images').child('$date');

    final StorageUploadTask uploadTask =
        storageRef.putFile(imageFile); // uploads file into Firebase Storage

    final StorageTaskSnapshot taskSnapshot = await uploadTask
        .onComplete; // waits for 'uploadTask' to complete then creates a snapshot

    var url = await taskSnapshot.ref
        .getDownloadURL(); // takes the URL of the imageFile

    DocumentReference DocRef =
        await db //uploads the URL into the collection photos
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100), child: InstanceTopAppBar()),
      endDrawer: DrawerMenu(),
      drawer: UserAccountDrawer(),
      body: Center(
        child: PhotoGridView(),
//        InstanceSecondAppBar()
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

class PhotoGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('instances')
            .document('instance1')
            .collection('photos')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Column(
                children: <Widget>[
                  Expanded(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: GridView.count(
                        key: PageStorageKey<String>('Preseves scroll position'),
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        padding: EdgeInsets.all(4.0),
                        // padding of the cards
                        childAspectRatio: 1.0,
                        // size of the card
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return GestureDetector(
                            child: GridTile(
                              child: Hero(
                                  tag: document.documentID,
                                  child: Image.network(document['url'],
                                      fit: BoxFit.cover)),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                        id: document.documentID,
                                        imageUrl: document['url']))),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
          }
        });
  }
}

class DetailsPage extends StatelessWidget {
  final String imageUrl;
  String id;

  DetailsPage({this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:
          FlatButton(onPressed: () => deleteData(), child: Icon(Icons.delete)),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: id,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, //TODO:might have to fix test needed
              height: double.infinity, //TODO://might have to fix test needed
              width: double.infinity, //TODO://might have to fix test needed
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  deleteData() {
    db
        .collection('instances')
        .document('instance1')
        .collection('photos')
        .document(id)
        .delete(); //TODO: ONLY DELETES IN DATABASE NOT STORAGE
  }
}
