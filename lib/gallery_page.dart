import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishallsealtheheavens/closed_instance.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'logic/login_authProvider.dart';
import 'local_device_details_page.dart';
import 'details_page.dart';

//final PermissionHandler _permissionHandler = PermissionHandler();

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            GallerySecondAppBar(),
            _buildPhotosTaken(),
            _buildSavedPhotos()
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosTaken() {
    FirebaseUser user = Provider.of<UserRepository>(context).user;

    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
      child: Column(
        children: <Widget>[
          Container(
//              padding: EdgeInsets.all(12.0),
              child: Text('Photos Taken',
                  style: Theme.of(context).textTheme.title)),
          StreamBuilder(
              stream: db.collection('users').document(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    return Container(
                        height: 200,
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            key: PageStorageKey<String>(
                                'Preseves scroll position'),
                            itemCount: snapshot.data['userImages'] != null
                                ? snapshot.data['userImages'].length
                                : 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                  width: 200,
                                  child: Card(
                                    elevation: 5.0,
                                    child: Hero(
                                        tag: snapshot.data['userImages'][index],
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 14.0),
                                          child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data['userImages'][index],
                                              fit: BoxFit.fill,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Container(
                                                      color: Colors.black,
                                                      child: Center(
                                                          child: Text(
                                                        'Photo does not exists anymore',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator()),
                                        )),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                              id: snapshot.data['userImages']
                                                  [index],
                                              imageUrl: snapshot
                                                  .data['userImages'][index],
                                            ))),
                              );
                            }));
                }
              }),
        ],
      ),
    );
  }

  listDeviceImages() async {
    Directory externalDirectory = Directory('storage/emulated/0/ISSTH'); //
//    externalDirectory.deleteSync(recursive: true); //deletes directory and files
    List<FileSystemEntity> images = externalDirectory.listSync(recursive: true);
    return images;
  }

  Widget _buildSavedPhotos() {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(24.0),
            child:
                Text('Saved Photos', style: Theme.of(context).textTheme.headline6)),
        FutureBuilder(
          future: listDeviceImages(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Text(
                  'Error: allow the app permission to store files in storage to show Saved Photos');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Container(
                  height: 200,
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                      key: PageStorageKey<String>('Preserves scroll position'),
                      itemCount: snapshot.data.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Card(
                              elevation: 5.0,
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: Image.file(snapshot.data[index],
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeviceImage(
                                        file: snapshot.data[index]))),
                        );
                      }),
                );
            }
          },
        )

      ],
    );
  }
}

class AllPhotosList extends StatelessWidget {

  getUserImages(FirebaseUser user) async  {
    var result = await Permission.storage.request();
//    var result = await _permissionHandler.requestPermissions([Permission.storage]);

  if (result == PermissionStatus.granted) {
    List allImages = []; // create empty list

    Directory externalDirectory = Directory('storage/emulated/0/ISSTH'); //
    externalDirectory.listSync(recursive: true).forEach((file) => allImages.add(file)); // add images from local device to allImage list

    DocumentSnapshot snapshot = await db.collection('users').document(user.uid).get();
    List networkImage = snapshot.data['userImages'];
    networkImage.forEach((file) => allImages.add(file)); // add images from db to allImage list

    return allImages;
  }


  }

  checkPermissions() async {

    PermissionStatus permission =  await Permission.storage.status;
//    print(permission);
  return permission;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<UserRepository>(context).user;

    return Container(
      color: Colors.grey[200],
      child: FutureBuilder(
        future: getUserImages(user),
        builder: (context, snapshot) {
          if(snapshot.hasError) return Text('Error: ${snapshot.error}');
          if(checkPermissions() == PermissionStatus.denied) return Center(child: FlatButton(child: Text('Allow')));
          switch(snapshot.connectionState) {
            case ConnectionState.waiting: return Text('Loading...');
            default:return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 2.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: snapshot.data[index] is File ? Image.file(snapshot.data[index], fit: BoxFit.fill) :
                        CachedNetworkImage(
                            imageUrl: snapshot.data[index],
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.fill),
                      ),
                    ),
                    onTap: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => snapshot.data[index] is File ? DeviceImage(file: snapshot.data[index]) :DetailsPage(
                                  id: snapshot.data[index]
                                  [index],
                                  imageUrl: snapshot
                                      .data[index],
                                ))),

                  );
                });
          }
        }
      ),
    );
  }
}

class GallerySecondAppBar extends StatelessWidget {
  const GallerySecondAppBar();

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      height: 48.0,
      width: 415.0,
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildViewText(),
              Stack(
                children: [
                  _buildViewIcon(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewIcon() {
    return PopupMenuButton(
        icon: Icon(Icons.arrow_drop_down),
        elevation: 23.0,
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                    //TODO:create a onpressed that views taken and saved separately
                    contentPadding: EdgeInsets.only(right: 0.0),
                    title: Text(
                      'Taken/Saved',
                      textScaleFactor: 1.2,
                    )),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: ListTile(
                  //TODO:create a onpressed that allows view all chronologically
                  title: Text(
                    'All',
                    textScaleFactor: 1.2,
                  ),
                  contentPadding: EdgeInsets.only(right: 0.0),
                ),
              ),
            ]);
  }

  Widget _buildViewText() {
    return Text('  View',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ));
  }
}
