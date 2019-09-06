import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/instance_page.dart';
import 'app_bar_bottom.dart';
import 'user_account_drawer.dart';
import 'app_bar_top_gallery.dart';

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
      appBar: GalleryTopAppBar(),
      drawer: UserAccountDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            GallerySecondAppBar(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: IconButton(
          icon: Icon(Icons.camera),
          iconSize: 35.0,
          //todo:should be better code to disable splash on button
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () =>
              Navigator.push(context, SlideRightRoute(page: InstancePage())),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomAppBar(),
    );
  }
}
