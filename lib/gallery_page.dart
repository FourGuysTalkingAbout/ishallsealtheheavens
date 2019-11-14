import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'logic/login_authProvider.dart';
import 'details_page.dart';
import 'save_files.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            GallerySecondAppBar(),
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
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading....');
                default:
                  return Container(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          key: PageStorageKey<String>(
                              'Preseves scroll position'),
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
                                        padding:
                                        const EdgeInsets.only(bottom: 14.0),
                                        child: CachedNetworkImage(
                                            imageUrl:snapshot.data['userImages'][index],
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url, error) => Container(color: Colors.black,
                                                child:Center(child: Text('Photo does not exists anymore', style: TextStyle(color: Colors.white),))),
                                            placeholder: (context, url) => CircularProgressIndicator(),),
                                      )),
                                ),
                              ),
                              onTap: () =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsPage(
                                                  id: snapshot
                                                      .data['userImages'][index],
                                                  imageUrl: snapshot
                                                      .data['userImages']
                                                  [index]))),
                            );
                          }));
              }
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
