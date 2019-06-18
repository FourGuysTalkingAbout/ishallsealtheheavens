import 'package:flutter/material.dart';
import 'app_bar_top.dart';

class InstanceTopAppBar extends AppBar {
  InstanceTopAppBar({Key key, Widget leading, Widget bottom})
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

class DrawerMenu extends StatelessWidget {
  const DrawerMenu();

  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: [
          new UserAccountsDrawerHeader(
              accountName: new Text('Name of Instance'), accountEmail: null),
          new ListTile(
            leading: new InstanceInfo(), // Test divider
          ),
          new Divider(
            color: Color(0xFF000000),
          ),
          new ListTile(
            leading: new DeleteInstance(),
          ),
          new Divider(
            color: Color(0xFF000000),
          ), // Test divider
          new ListTile(
              leading: new IconButton(
                  icon: new Icon(Icons.search), onPressed: () => Text('Blah')),
              title: TextField(),
              trailing: IconButton(
                  icon: new Icon(Icons.play_arrow),
                  onPressed: () => Text('Pressed')))
        ],
      ),
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
      onPressed: () => Text(
            "Test instance info",
          ),
      child: Text("Instance Info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

class DeleteInstance extends StatelessWidget {
  DeleteInstance({Key key}) : super(key: key);

  PopUpMenu popUpConfirm = new PopUpMenu();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => popUpConfirm.confirm(
          context,
          'Are you sure you want to delete this Instance?',
          'Instance will be deleted '
          'Your images/edits will be archived'),
      child: Text("Delete Instance",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
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
      'Name of In',
      textAlign: TextAlign.center,
    );
  }
}

class PopUpMenu {
  // logic
  _confirmResult(bool isYes, BuildContext context) {
    if (isYes) {
      print('test yes');
      Navigator.pop(context);
    } else {
      print('test no');
      Navigator.pop(context);
    }
  }

  confirm(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(description)],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => _confirmResult(false, context),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => _confirmResult(true, context),
                child: Text('Yes'),
              )
            ],
          );
        });
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
            children: [
              new HostText(),
              Stack(
                children: [
                  new EditIcon(),
                  Align(
                    alignment: Alignment(1, 0.70),
                    child: Text('       Edit'),
                  )
                ],
              ),
            ],
          ),
          new Row(
            children: [
              CheckIconButton(),
              AddContact(),
              new Container(),
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
    var entranceCode = 'IN3CH';
    String instanceName = 'Name of In';
    String instanceDescription = '';
    int numberOfGuests;

    return PopupMenuButton(
        icon: Icon(Icons.edit),
        elevation: 23.0,
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
               PopupMenuItem(
                child: ListTile(
                  //TODO:create a onpressed that edits 'instanceName'
                    contentPadding: EdgeInsets.only(right: 0.0),
                    leading: Text('Name:'),
                    title: Text('$instanceName',textScaleFactor: 1.2,)
                ),
              ),
              PopupMenuDivider(),
               PopupMenuItem(
                child: ListTile(
                  //TODO:create a onpressed that allows to edit 'entranceCode?
                  //TODO:make the 'entranceCode' bigger font
                  title: Text('Entrance Code: $entranceCode '),
                  contentPadding: EdgeInsets.only(left: 55.0), //todo:change back to 0.0
                ),
              ),
              PopupMenuDivider(),
              const PopupMenuItem(
                child: ListTile(
                  //TODO:create a dialog that is allows writing descriptions of instance
                  title: Text('Set Description'),
                  contentPadding: EdgeInsets.only(right: 0.0),
                ),
              ),
              PopupMenuDivider(),
              const PopupMenuItem(
                //TODO: implement a way to limit guests in the instance
                child: ListTile(
                  title: Text('Limit number of Guests'),
                  contentPadding: EdgeInsets.only(right: 0.0),
                ),
              ),
              PopupMenuDivider(),
              const PopupMenuItem(
                //TODO: is this a Text location or some sort of google maps thing?
                child: ListTile(
                  title: Text('Set Location'),
                  contentPadding: EdgeInsets.only(right: 0.0),
                ),
              ),
            ]);
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
        ));
  }
}

class AddContact extends StatelessWidget {
  const AddContact();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.person_add),
        iconSize: 35.0,
        alignment: Alignment.center,
        onPressed: () => Text('Blah'));
  }
}

class CheckIcon extends StatelessWidget {
  const CheckIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
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
        onPressed: () => Text('test press'));
  }
}
