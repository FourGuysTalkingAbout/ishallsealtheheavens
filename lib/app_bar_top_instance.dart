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
  }
}

class SecondAppBar extends StatelessWidget {
  const SecondAppBar();

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
            children:[
              new hostText(),
              Stack(
                children: [
                  new editIcon(),
                  Align(
                    alignment: Alignment(1,0.70),
                    child: Text('       Edit'),
                  )
                ],
              ),
            ],
          ),
          new Row(
            children:[
              checkIconButton(),
              addContact(),
              new Container(
              ),
              new checkIcon(),
            ],
          )
        ],
      ),
    );
  }
}

class editIcon extends StatelessWidget {
  const editIcon();

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: Icon(Icons.mode_edit),
        onPressed: () => null
    );
  }
}

class hostText extends StatelessWidget {
  const hostText();

  @override
  Widget build(BuildContext context) {
    return new Text('  Host',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        )
    );
  }
}

class addContact extends StatelessWidget {
  const addContact();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
            Icons.person_add
        ),
        iconSize: 35.0,
        alignment: Alignment.center,
        onPressed: ()=> Text('Blah'));
  }
}

class checkIcon extends StatelessWidget {
  const checkIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.check),
      iconSize: 35.0,
      color: Colors.black,
      onPressed: () => Text('TEST MEE'),
    );
  }
}

class checkIconButton extends StatelessWidget {
  const checkIconButton();

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: Icon(Icons.arrow_downward),
        iconSize: 35.0,
        onPressed: () => Text('test press')
    );
  }
}


