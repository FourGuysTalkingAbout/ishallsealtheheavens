import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishallsealtheheavens/saveFile.dart';
import 'package:path_provider/path_provider.dart';

import 'app_bar_top_instance.dart';
import 'user_account_drawer.dart';
import 'package:intl/intl.dart';

final db = Firestore.instance;



class InstancePage extends StatefulWidget {
  final SaveFile saveFile;

//  final String value;
  final String instanceName;
  final String instanceId;
  final bool firstPic;

  InstancePage({Key key, this.instanceName, this.instanceId, this.firstPic, this.saveFile})
      : super(key: key);

  @override
  _InstancePageState createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  List<String> images = List<String>();


  openCamera() async {
    //TODO: implement a better naming convention for the 'imageName'
//    final String imageName = '${Random().nextInt(100)}';
    final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera); //returns a File after picture is taken


    SaveFile().writeImage(imageFile);
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;

    // await imageFile.copy('$appDocPath/image1.png');

    //'images' is a folder in Firebase Storage,
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('images').child('$date');

    final StorageUploadTask uploadTask =
        storageRef.putFile(imageFile); // uploads file into Firebase Storage

    final StorageTaskSnapshot taskSnapshot = await uploadTask
        .onComplete; // waits for 'uploadTask' to complete then creates a snapshot

    var url = await taskSnapshot.ref
        .getDownloadURL(); // takes the URL of the imageFile

    saveToFireStore(url);
  }
  saveToFireStore(String url) {
    final DocumentReference postRef = db.document('instances/${widget.instanceId}');
    db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, {'photoURL': FieldValue.arrayUnion([url])});
      }
    });
  }

  isActive() {// sets instance 'active' from true to false; making it appear in past Instance
              //TODO: allow host to select how long instance stays active.
    Future.delayed(const Duration(seconds: 3), () {
      DocumentReference docRef = db.document('instances/${widget.instanceId}');
      db.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(docRef);
        if (postSnapshot.exists) {
          await tx.update(docRef, {'active': false});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    isActive(); // find way to set active to false or true
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[400],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: InstanceTopAppBar(
            title: Text(widget.instanceName),
          )),
      endDrawer: DrawerMenu(),
      drawer: UserAccountDrawer(),
      body: Center(
        child: PhotoGridView(
          docId: widget.instanceId,
          instanceName: widget.instanceName,
        ),
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
//      bottomNavigationBar: CustomAppBar(),
    );
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
                return  GestureDetector(
                  child: Card(
                    elevation: 5.0,
                    child: Hero(
                        tag: snapshot.data[index],
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Image.network(snapshot.data[index],
                              fit: BoxFit.fill
                          ),
                        )),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsPage(
                              id: snapshot.data[index],
                              imageUrl: snapshot.data[index]))),
                );
              });
        }
      },
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String imageUrl;
  final String id;

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
