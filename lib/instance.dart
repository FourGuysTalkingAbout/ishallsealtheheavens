import 'package:flutter/material.dart';


class TopAppBar extends AppBar {
  TopAppBar({Key key, Widget leading, Widget title, Widget flexibleSpace})
      : super(
    key: key,
    leading: Builder(builder: (BuildContext context) {
      return new FlatButton(
          onPressed: () => {},
          child: new Text("FS",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)));
    }),
    title: Text(
      "Name Of In",
      textAlign: TextAlign.center,
    ),
    centerTitle: true,
    actions: <Widget>[
      new IconButton(
          icon: new Icon(Icons.dehaze), onPressed: () => print("tap"))
    ],
  );
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return BottomAppBar(
      elevation: 5.0,
      color: Colors.grey,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: null),
          IconButton(icon: Icon(Icons.search), onPressed: null)
        ],
      ),
    );
  }
}
