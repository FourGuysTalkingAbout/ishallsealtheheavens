import 'package:flutter/material.dart';

class UserAccountDrawer extends StatefulWidget {
  UserAccountDrawer({Key key,}) : super(key: key);
  @override
  _UserAccountDrawerState createState() => _UserAccountDrawerState();
}

class _UserAccountDrawerState extends State<UserAccountDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(decoration: BoxDecoration(color: Color(0xFFD1C4E9)),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(backgroundImage: AssetImage('images/apex_lestley.png'),maxRadius: 50,),
                Text('Kikashi-Sensei@hotmail.com',style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
              ],
            ),
          ),
          ListTile(
          ),
          Divider(color:Colors.black,),
          ListTile(title: Text('Username:'),
          ),
          Divider(color:Colors.black,),
          ListTile(
          ),
          Divider(color:Colors.black,),
          ListTile(
          ),
          Divider(color:Colors.black,),
        ],
      ),
    );
  }
}
