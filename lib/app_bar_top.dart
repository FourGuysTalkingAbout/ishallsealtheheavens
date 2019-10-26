import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/instance_page.dart';
import 'package:provider/provider.dart';

import 'logic/login_authProvider.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key key, Widget leading, Widget bottom, Widget title})
      : super(
    key: key,
    backgroundColor: Colors.deepPurple,
    leading: Builder(builder: (BuildContext context) {
      return new TopBarText();
    }),
    title: new BarTitle("Home"),
    centerTitle: true,
    actions: <Widget>[
      new IconButton(
          icon: new Icon(Icons.dehaze), onPressed: () => print("tap"))
    ],
  );
}

class TopBarText extends StatelessWidget {
  const TopBarText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
        onPressed: () {
          print('DRAWER');
          Scaffold.of(context).openDrawer();

        },
        child: new Text("FS",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white)));
  }
}

class BarTitle extends StatelessWidget{
  final String title;

  const BarTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: buildTextStyle,
      textAlign: TextAlign.center,
    );

  }

  TextStyle get buildTextStyle {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }
}


