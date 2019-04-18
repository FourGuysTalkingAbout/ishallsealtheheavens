import 'package:flutter/material.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key key, Widget leading, Widget bottom})
      : super(
    key: key,
    backgroundColor: Colors.deepPurple,
    leading: Builder(builder: (BuildContext context) {
      return new _topBarText();
    }),
    title: _topBarTitle(),
    centerTitle: true,
  );
}

class drawerMenu extends StatelessWidget{
  const drawerMenu();

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

class instanceInfo extends StatelessWidget {
  const instanceInfo({
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

class deleteInstance extends StatelessWidget {
  const deleteInstance({
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

class _topBarTitle extends StatelessWidget {
  const _topBarTitle({
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

class _topBarText extends StatelessWidget {
  const _topBarText({
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
/*
class CustomAppBar extends StatelessWidget {
  const CustomAppBar();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return BottomAppBar(
      elevation: 1.0,
      color: Colors.grey[300],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: IconButton(
                  iconSize: 40.0,
                  icon: Icon(Icons.people),
                  onPressed: () {
                    print("I was tapped");
                  }),
            ),
          ),
          Container(
            child: InkWell(
              child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: IconButton(
                      iconSize: 50.0,
                      icon: Image.asset('images/IconIcecream.png'),
                      onPressed: () {
                        print('I was tapped');
                      })),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.collections),
              onPressed: () {
                print('I was tapped');
              },
            ),
          )
        ],
      ),
    );
  }
}

*/
