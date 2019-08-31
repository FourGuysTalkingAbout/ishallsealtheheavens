import 'package:flutter/material.dart';
import 'app_bar_top.dart';

class GalleryTopAppBar extends AppBar {
  GalleryTopAppBar({Key key, Widget leading, Widget bottom})
      : super(
          key: key,
          backgroundColor: Colors.deepPurple,
          leading: Builder(builder: (BuildContext context) {
            return new TopBarText();
          }),
          title: TopBarTitle(),
          centerTitle: true,
        );
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
          new Row(
            children: [
              new ViewText(),
              Stack(
                children: [
                  new ViewIcon(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopBarTitle extends StatelessWidget {
  const TopBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Text(
      'Gallery',
      textAlign: TextAlign.center,
    );
  }
}

class ViewIcon extends StatelessWidget {
  const ViewIcon();

  @override
  Widget build(BuildContext context) {
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
}

class ViewText extends StatelessWidget {
  const ViewText();

  @override
  Widget build(BuildContext context) {
    return new Text('  View',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ));
  }
}
