import 'package:flutter/material.dart';

class AllTopAppBar extends AppBar {

//change title when on specific Page
  AllTopAppBar({Widget title, Widget leading, Widget bottom, Key key, bool centerTitle })
      : super(
      backgroundColor: Colors.deepPurple,
      centerTitle: centerTitle,
      key: key,
      title: title,
      leading: _FSLogo(),
      bottom : bottom,
  );
}

class _FSLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        child: new Text("FS",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white)));
  }
}
