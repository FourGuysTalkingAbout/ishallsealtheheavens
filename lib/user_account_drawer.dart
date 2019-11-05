import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/login_authProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserAccountDrawer extends StatelessWidget {
  //  //TODO Fix Display name for Email Login
//  //TODO allow Email/login to create display name
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          //TODO:Made it look like the Figma Design, don't know if it's worth all the extra widgets.
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
                  backgroundImage: NetworkImage(user.user.photoUrl),
                  maxRadius: 50,
                ),
                Text(user.user.email,
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
                (user.user.displayName == null
                    ? 'Create a Username'
                    : user.user.displayName))),
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

class SignOutButton extends StatelessWidget {
  final _auth = UserRepository.instance();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        _auth.signOut();
        Navigator.pop(context);
      },
      textColor: Colors.black,
      child: Container(
        alignment: Alignment(-1.17, 0),
        child: Text('Sign Out'),
      ),
    );
  }
}
