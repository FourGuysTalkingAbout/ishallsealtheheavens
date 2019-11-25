import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'logic/login_authProvider.dart';

class InstanceAppBar extends StatelessWidget {
  final String instanceID;
  final Widget title;


  const InstanceAppBar({Key key, this.instanceID, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<UserRepository>(context).user;

    return StreamBuilder(
        stream: db.collection('instances').document(instanceID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              String host = snapshot.data['host'] ?? '';
              List users = snapshot.data['userNames'];
              int guests = snapshot.data['Guests'];
              bool active = snapshot.data['active'];
              bool hostCheck = (host == user.uid);


              return AppBar(
                centerTitle: true,
                backgroundColor: Colors.deepPurple,
                leading: _buildFSLogo(),
                title: title,
                actions: <Widget>[
                  hostCheck == true && active == true
                      ? _buildHostPopUpMenu(
                          description: snapshot.data['instanceDescription'],
                          userLimit: snapshot.data['userLimit'].toString(),
                          instanceName: snapshot.data['instanceName'],
                          instanceCode: snapshot.data['instanceCode'],
                          users: users,
                        )
                      : _buildGuestPopUpMenu(
                          description: snapshot.data['instanceDescription'],
                          users: users, guests: guests)
                ],
              );
          }
        });
  }

  Widget _buildFSLogo() {
    return Builder(
      builder: (context) => FlatButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          child: Text("FS",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),

    );
  }

  Widget _buildGuestPopUpMenu({String description, List users, int guests FirebaseUser user}) {

    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: GestureDetector(
              child: ListTile(title: Text('Users')),
              onTap: () => _showUsers(
                  context: context, users: users, guests: guests)), // add list of users
        ),
        PopupMenuItem(
          child: GestureDetector(
            child: ListTile(title: Text('Description')),
            onTap: () => _readDescription(context, description ?? ''),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            child: ListTile(
              title: Text('Leave Instance')),
            onTap: () => _leaveInstance(context, user),
          ),
        )
      ],
    );
  }

  Widget _buildHostPopUpMenu(
      {String description,
      String userLimit,
      List users,
      String instanceName,
      String instanceCode}) {

    return PopupMenuButton(
        icon: Icon(FontAwesomeIcons.edit),
        elevation: 23.0,
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                      contentPadding: EdgeInsets.only(right: 0.0),
                      leading: Text('Name:'),
                      title: Text('$instanceName',
                          style: Theme.of(context).textTheme.title)),
                  onTap: () {
                    _changeName(context, instanceName)
                        .then((val) => Navigator.pop(context));

                  },
                ),
              ),

              PopupMenuDivider(),

              PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0),
                    leading: Text('Entrance Code:'),
                    //TODO:FUTURE create a onpressed that allows to edit 'entranceCode?
                    //TODO:make the 'entranceCode' bigger font
                    title: Text(instanceCode,
                        style: Theme.of(context).textTheme.title),
                  ),
                ),
              ),
              PopupMenuDivider(),

              PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                    //TODO:create a dialog that is allows writing descriptions of instance
                    title: Text('Description'),
                    contentPadding: EdgeInsets.only(right: 0.0),
                  ),
                  onTap: () {
                    _changeDescription(context, description)
                        .then((val) => Navigator.pop(context));
                  },
                ),
              ),
              PopupMenuDivider(),

              PopupMenuItem(
                child: GestureDetector(
                    child: ListTile(title: Text('Users')),
                    onTap: () {
                      _showUsers(context: context, users: users);
//                  );
                    }), // add list of users
              ),

              PopupMenuItem(
                child: GestureDetector(
                  child: ListTile(
                    title: Text('Limit number of Guests'),
                    contentPadding: EdgeInsets.only(right: 0.0),
                  ),
                  onTap: () {
                    _changeLimitUsers(context, userLimit)
                        .then((val) => Navigator.pop(context));
                  },
                ),
              ),
//              PopupMenuDivider(),
//
//               PopupMenuItem(
//                //TODO: Future set location of instance
//                child: ListTile(
//                  title: Text('Set Location'),
//                  contentPadding: EdgeInsets.only(right: 0.0),
//                ),
//              ),
              PopupMenuDivider(),
//
              PopupMenuItem(
                //TODO: Future set location of instance
                child: GestureDetector(
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.checkSquare),
                      title: Text('End Instance'),
                      contentPadding: EdgeInsets.only(right: 0.0),
                    ),
                    onTap: () {
                      _endInstance(context);
                    }),
              ),
            ]);
  }

  _changeLimitUsers(BuildContext context, String userLimit) async {
    final limitTextController = TextEditingController(text: userLimit);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Limit of Users'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  controller: limitTextController,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Change the number of user allowed'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Change'),
              onPressed: () {
                db
                    .collection('instances')
                    .document(instanceID)
                    .updateData({'userLimit': limitTextController.text});
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

  Future<void> _changeDescription(
      BuildContext context, String description) async {
    final descriptionController = TextEditingController(text: description);
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
                  controller: descriptionController,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Enter a description'),
                ),
//                Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Set'),
              onPressed: () {
                db.collection('instances').document(instanceID).updateData(
                    {'instanceDescription': descriptionController.text});
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

  Future<void> _changeName(BuildContext context, String instanceName) async {
    final instanceNameController = TextEditingController(text: instanceName);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change the name of your Instance'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  maxLines: 1,
                  maxLength: 15,
                  controller: instanceNameController,
                  decoration: InputDecoration(
                      counterText: '', hintText: 'Enter a a new name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Change'),
              onPressed: () {
                db
                    .collection('instances')
                    .document(instanceID)
                    .updateData({'instanceName': instanceNameController.text});
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

  Future _endInstance(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to end the instance?'),
          content: Text('You can only view pictures after ending.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                db
                    .collection('instances')
                    .document(instanceID)
                    .updateData({'active': false});
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _leaveInstance(BuildContext context, FirebaseUser user ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to leave?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            MaterialButton(
              child: Text('Confirm'),
              onPressed: () async{
                //removes user displayName from 'users' array in the instance.
                await db.collection('instances').document(instanceID).updateData({'users': FieldValue.arrayRemove([user.displayName])});

                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel')),
          ],),
        );
      }
    );
  }

  _readDescription(BuildContext context, String description) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('What\'s this is about'),
            content: Text(description),
          );
        });
  }


  _showUsers({BuildContext context, List users, int guests}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Users'),
                  Text('Guests: $guests',style: Theme.of(context).textTheme.subtitle,)
                ],
              ),
              content: Container(
                height: 600,
                width: 400,
                child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemCount: users.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(users == null ? 'Guest' : users[index]));
                    }),
              ));
        });
  }
}
