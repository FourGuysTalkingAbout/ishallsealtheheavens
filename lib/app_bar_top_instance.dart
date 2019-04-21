import 'package:flutter/material.dart';

class InstanceTopAppBar extends AppBar {
  InstanceTopAppBar({Key key, Widget leading, Widget bottom})
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
            leading: new InstanceInfo(), // Test divider
          ),
          new Divider(color: Color(0xFF000000),),
          new ListTile(
            leading:  new DeleteInstance(),
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

class InstanceSecondAppBar extends StatelessWidget {
  const InstanceSecondAppBar();

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
              new HostText(),
              Stack(
                children: [
                  new EditIcon(),
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
              CheckIconButton(),
              AddContact(),
              new Container(
              ),
              new CheckIcon(),
            ],
          )
        ],
      ),
    );
  }
}

class EditIcon extends StatelessWidget {
  const EditIcon();

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: Icon(Icons.mode_edit),
        onPressed: () => null
    );
  }
}

class HostText extends StatelessWidget {
  const HostText();

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

class AddContact extends StatelessWidget {
  const AddContact();

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

class CheckIcon extends StatelessWidget {
  const CheckIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.check),
      iconSize: 35.0,
      color: Colors.black,
      onPressed: () => Text('TEST MEE'),

    );
  }
}

class CheckIconButton extends StatelessWidget {
  const CheckIconButton();

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: Icon(Icons.arrow_downward),
        iconSize: 35.0,
        onPressed: () => Text('test press')
    );
  }
}

