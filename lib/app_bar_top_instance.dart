import 'package:flutter/material.dart';
import 'app_bar_top.dart';
import 'instance_page.dart';

class InstanceTopAppBar extends AppBar {
  InstanceTopAppBar(
      {Key key,
      Widget leading,
      Widget bottom,
      Widget title,
      String instanceName,
      String instanceCode,
        String instanceID,
      })
      : super(
          key: key,
          backgroundColor: Colors.deepPurple,
          leading: FlatButton(
              onPressed: () => print('FS logo'),
              child: Text("FS",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          title: title,
          centerTitle: true,
          bottom: BottomInstanceBar(
              instanceID :instanceID,
              instanceName: instanceName,
              instanceCode: instanceCode),
        );
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu();

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text('Name of Instance'), accountEmail: null),
          ListTile(
            leading: InstancesInfo(), // Test divider
          ),
          Divider(
            color: Color(0xFF000000),
          ),
          ListTile(
            leading: DeleteInstance(),
          ),
          Divider(
            color: Color(0xFF000000),
          ), // Test divider
          ListTile(
              leading: IconButton(
                  icon: Icon(Icons.search), onPressed: () => Text('Blah')),
              title: TextField(),
              trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () => Text('Pressed')))
        ],
      ),
    );
  }
}

class InstancesInfo extends StatelessWidget {
  const InstancesInfo({
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

  final PopUpMenu popUpConfirm = PopUpMenu();

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
    return Text(
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

class BottomInstanceBar extends PreferredSize {
  final String instanceCode;
  final String instanceName;
  final String instanceID;

  const BottomInstanceBar({this.instanceID, this.instanceCode, this.instanceName});

  Widget _buildCheckIcon() {
    return IconButton(
      icon: Icon(Icons.check),
      iconSize: 35.0,
      color: Colors.black,
      onPressed: () => print('TEST MEE'),
    );
  }

  Widget _buildDownArrow() {
    return IconButton(
        icon: Icon(Icons.arrow_downward),
        iconSize: 35.0,
        onPressed: () => print('test press'));
  }

  Widget _buildAdd() {
    return IconButton(
        icon: Icon(Icons.person_add),
        iconSize: 35.0,
        alignment: Alignment.center,
        onPressed: () => print('Add people?'));
  }

  Widget _buildHost() {
    return Text('  Host',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection('instances').document(instanceID).snapshots(),
      builder: (context, snapshot) {
      if (snapshot.data != null) {
        return  Container(
          height: 50,
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildHost(),
                  Stack(
                    children: [
                      _buildPopUpMenus(snapshot.data['instanceDescription']),
                      Align(
                        alignment: Alignment(1, 0.70),
                        child: Text('       Edit'),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildDownArrow(),
                  _buildAdd(),
                  _buildCheckIcon(),
                ],
              )
            ],
          ),
        );
      } else {
        return Container();
      }
      }
    );
  }

  Widget _buildPopUpMenus(String description) {

    return PopupMenuButton(
        icon: Icon(Icons.edit),
        elevation: 23.0,
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[

              PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                      //TODO: create a onpressed that edits 'instanceName'
                      contentPadding: EdgeInsets.only(right: 0.0),
                      leading: Text('Name:'),
                      title: Text('$instanceName', textScaleFactor: 1.2)),
                  onTap: () {
                    print('HELLO');
//                    _showDialog(context);
                    Navigator.of(context).pop();
                  },
                ),
              ),

              PopupMenuDivider(),

              PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(right: 0.0),
                    leading: Text('Entrance Code: '),
                    //TODO:create a onpressed that allows to edit 'entranceCode?
                    //TODO:make the 'entranceCode' bigger font
                    title: Text(instanceCode),
                  ),
//                  onTap: () => _neverSatisfied(context),
                ),
              ),
              PopupMenuDivider(),

               PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                    //TODO:create a dialog that is allows writing descriptions of instance
                    title: Text('Set Description'),
                    contentPadding: EdgeInsets.only(right: 0.0),
                  ),
                  onTap: () {
                    _neverSatisfied(context, description).then((val) => Navigator.pop(context));
                  },
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
  Future<void> _neverSatisfied(BuildContext context, String description) async {
    final myController = TextEditingController(
      text: description
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Description of Instance'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  maxLines: 5,
                  controller: myController,
                  decoration: InputDecoration.collapsed(hintText: 'Enter a description'),
                ),
//                Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Change'),
              onPressed: () {
                db.collection('instances').document(instanceID).updateData({'instanceDescription': myController.text});
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      // context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Alert Dialog title"),
          content: Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
