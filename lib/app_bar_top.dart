import 'package:flutter/material.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key key, Widget leading, Widget bottom})
      : super(
          key: key,
          backgroundColor: Colors.deepPurple,
          leading: Builder(builder: (BuildContext context) {
            return new TopBarText();
          }),
          title: new TopBarTitle(),
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

class TopBarTitle extends StatelessWidget {
  const TopBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Text(
      "Name Of In",
      textAlign: TextAlign.center,
    );
//    return Column(
//      StreamedWidget(
//        initialData: streamedInstanceName.value,
//        stream: streamedInstanceName.outStream,
//        builder: (context, snapshot) => Text("Time: ${snapshot.data}"),
//      ),
//    );
  }
}
