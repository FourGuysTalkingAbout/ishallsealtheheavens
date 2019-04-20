import 'package:flutter/material.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key key, Widget leading, Widget bottom})
      : super(
    key: key,
    backgroundColor: Colors.deepPurple,
    leading: Builder(builder: (BuildContext context) {
      return new _TopBarText();
    }),
    title: _TopBarTitle(),
    centerTitle: true,
  );
}

class DrawerMenu extends StatelessWidget{
  const DrawerMenu();

  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children:[
          new UserAccountsDrawerHeader(
              accountName: new Text ('Name of Instance'),
              accountEmail: null
          ),
          new ListTile(
            leading: new instanceInfo(), // Test divider
          ),
          new Divider(color: Color(0xFF000000),),
          new ListTile(
            leading:  new deleteInstance(),
          ),
          new Divider(color: Color(0xFF000000),), // Test divider
          new ListTile(
              leading: new IconButton(icon: new Icon(Icons.search), onPressed: ()=> Text('Blah')),
              title: TextField(),
              trailing: IconButton(icon: new Icon(Icons.play_arrow), onPressed:()=> Text('Pressed'))
          )
        ],
      ) ,
    );
  }
}

class InstanceInfo extends StatelessWidget {
  const InstanceInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: ()=> Text("Test instance info",),
      child: Text("Instance Info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
      ),
    );
  }
}

class DeleteInstance extends StatelessWidget {
  const DeleteInstance({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: ()=> Text("Test delete instance",),
      child: Text("Delete Instance",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
      ),
    );
  }
}

class _TopBarTitle extends StatelessWidget {
  const _TopBarTitle({
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

class _TopBarText extends StatelessWidget {
  const _TopBarText({
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

