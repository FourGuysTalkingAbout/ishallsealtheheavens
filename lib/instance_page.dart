import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishallsealtheheavens/detailsPage.dart';
import 'package:ishallsealtheheavens/saveFile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import 'logic/login_authProvider.dart';
import 'saveFile.dart';
import 'app_bar_top_instance.dart';
import 'user_account_drawer.dart';

final db = Firestore.instance;

final saveFile = SaveFile();
final userRepository = UserRepository.instance();


class InstancePage extends StatefulWidget {
  final String instanceName;
  final String instanceId;
  final String instanceCode;
  final bool firstPic;


  InstancePage({Key key, this.instanceName, this.instanceId, this.firstPic, this.instanceCode})
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
    final currentDate = formatter.format(now);

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera); //returns a File after picture is taken


    StorageMetadata metaData = StorageMetadata(customMetadata:<String, String>{
      'author': userRepository.user.displayName, 'instanceName': widget.instanceName
    });

//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    String appDocPath = appDocDir.path;

//    saveFile.writeImage(imageFile);

//    await imageFile.copy('$appDocPath/image1.png');

    //'images' is a folder in Firebase Storage,
     final StorageReference storageRef =
         FirebaseStorage.instance.ref().child('images').child('$currentDate.jpg');

     final StorageUploadTask uploadTask =
         storageRef.putFile(imageFile,metaData); // uploads file into Firebase Storage

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

  saveAsUserImage(String url){
    final DocumentReference postRef = db.document('users/${userRepository.user.uid}');
    db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if(postSnapshot.exists) {
        await tx.update(postRef, {
          'userImages': FieldValue.arrayUnion([url])
        });
      }
    });

  }

  isActive() {

    Future.delayed(const Duration(hours: 24), () {
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

//    FirebaseUser user = Provider.of<UserRepository>(context).user;
//    print(user);
    isActive(); // find way to set active to false or true
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[400],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: InstanceTopAppBar(
            title: Text(widget.instanceName),
            instanceID: widget.instanceId,
            instanceName: widget.instanceName,
            instanceCode: widget.instanceCode,
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
                return GestureDetector(
                  child: Card(
                    elevation: 5.0,
                    child: Hero(
                        tag: snapshot.data[index],
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Image.network(snapshot.data[index],
                              fit: BoxFit.fill),
                        )),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsPage(
                              id: snapshot.data[index],
                              imageUrl: snapshot.data[index],))),
                );
              });
        }
      },
    );
  }
}



