import 'package:flutter/material.dart';
//import 'dart:async';

class SecondAppBar extends StatelessWidget {
  const SecondAppBar();

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      height: 48.0,
      width: 415.0,
      color: Colors.white,
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
              addContact(),
              new Container(
              ),
              new checkIconButton(),
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
    return new ImageIcon(new AssetImage('images/Vector.png'),
      color: Colors.black,
      size: 50.0,
    );
  }
}

class checkIconButton extends StatelessWidget {
  const checkIconButton();

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new checkIcon(),
        onPressed: () => Text('test press')
    );
  }
}


