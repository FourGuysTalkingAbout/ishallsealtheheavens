import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/login_authProvider.dart';



class UserAccountDrawer extends StatelessWidget {
  //  //TODO Fix Display name for Email Login
//  //TODO allow Email/login to create display name
  @override
  Widget build(BuildContext context) {

    final FirebaseUser user = Provider.of<UserRepository>(context).user;

    if (user.isAnonymous) {
      return buildAnonDrawer();
    } else {
      return Drawer(
        child: ListView(
          children: <Widget>[
            //TODO: Figure out if more options are needed or not.
            DrawerHeader(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: Divider.createBorderSide(context,
                          color: Colors.black, width: 2.0)),
                  color: Color(0xFFD1C4E9)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl == null ? '' : user.photoUrl ),
                    maxRadius: 50,
                  ),
                  Text(user.email?? '',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              color: Color(0xff757575),
              height: 10.0,
            ),
//          ListTile(),
//          Divider(color: Colors.black),
            ListTile(
                title: Text(
                    (user.displayName?? ''))),
            Divider(
                color: Colors.black),
            ListTile(
              title: Text('Send Feedback'),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text('Get Help'),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: SignOutButton(),
            ),
            Divider(
              color: Colors.black,
            )
          ],
        ),
      );
    }

  }


  Widget buildAnonDrawer() {
    return Drawer (
      child: ListView(
        children: <Widget>[
          ListTile(title: Text('Send Feedback')),
          ListTile(title: Text('Get Help')),
          ListTile(title: SignOutButton()),
        ],
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  final _auth = UserRepository.instance();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        _auth.signOut();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      textColor: Colors.black,
      child: Container(
        alignment: Alignment(-1.17, 0),
        child: Text('Sign Out'),
      ),
    );
  }
}

