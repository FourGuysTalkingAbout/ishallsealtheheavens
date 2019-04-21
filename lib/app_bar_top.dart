import 'package:flutter/material.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key key, Widget leading, Widget bottom})
      : super(
    key: key,
    backgroundColor: Colors.deepPurple,
    leading: Builder(builder: (BuildContext context) {
      return new TopBarText();
    }),
    title: new BarTitle("No Instance"),
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
        onPressed: () => {},
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


class SecondAppBar extends StatelessWidget {
  const SecondAppBar();

  final int _numInstances = 0;

  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: 415.0,
      color: Colors.grey[300],
      child: Center(
        child: BarTitle("You have $_numInstances instances"),
      ),


      /*
     *  Will be dynamic in the future. It should tell user how many instances
     *  he/she has.
     *
     *  ie. how many he/she is hosting and how many he/she joined.
     *
     *
     * */

    );
  }
}

