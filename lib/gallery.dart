import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/app_bar.dart';
import 'package:ishallsealtheheavens/detailsPage.dart';
import 'package:ishallsealtheheavens/instance_page.dart';
import 'package:ishallsealtheheavens/saveFile.dart';
import 'package:ishallsealtheheavens/user_account_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'app_bar_bottom.dart';
import 'logic/login_authProvider.dart';

enum GalleryView { Taken, All }

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
//      appBar: AllTopAppBar(),
//      drawer: UserAccountDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GallerySecondAppBar(),
            PhotosTakenList(),
          ],
        ),
      ),
    );
  }
}

final saveFile = SaveFile();

class PhotosTakenList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<UserRepository>(context).user;

//Photos taken
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(12.0),
            child: Text('Photos Taken', style: Theme.of(context).textTheme.title)),
        StreamBuilder(
            stream: db.collection('users').document(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              }
              return Container(
                height: 200,
//                height: MediaQuery.of(context).size.height * 0.30,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    key: PageStorageKey<String>('Preseves scroll position'),
                    itemCount: snapshot.data['userImages'].length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          width: 200,
                          child: Card(
                            elevation: 5.0,
                            child: Hero(
                                tag: snapshot.data['userImages'][index],
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: Image.network(snapshot.data['userImages'][index],
                                      fit: BoxFit.fill),
                                )),
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                    id: snapshot.data['userImages'][index],
                                    imageUrl: snapshot.data['userImages'][index]))),
                      );
                    })
              );
            }),
      ],
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


