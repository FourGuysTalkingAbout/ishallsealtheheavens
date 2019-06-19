import 'package:flutter/material.dart';
import 'logic/login_authentication.dart';



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
          //TODO:Made it look like the Figma Design, don't know if it's worth all the extra widgets.
          DrawerHeader(margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            decoration: BoxDecoration(border: Border(
            bottom: Divider.createBorderSide(context,color: Colors.black,width: 2.0)
          ),
              color: Color(0xFFD1C4E9)),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(backgroundImage: AssetImage('images/apex_lestley.png'),maxRadius: 50,),
                Text('Kikashi-Sensei@hotmail.com',style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
              ],
            ),
          ),
          Container(color: Color(0xff757575),
            height: 10.0,
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

          ListTile(
            title: LoginButton(),
          ),

          Divider(
            color: Colors.black,
          )

        ],
      ),
    );
  }
}


class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FlatButton(
            onPressed: () => authService.signOut(),
            textColor: Colors.black,
            child: Container(
              alignment: Alignment(-1.17, 0),
              child: Text(
                'Sign Out',
              ),
            ),
          );
        } else {
          return FlatButton(
            onPressed: () => authService.googleSignIn(),
            textColor: Colors.black,
            child: Container(
              alignment: Alignment(-1.17, 0),
              child: Text('Sign In'),
            ),
          );
        }
      },
    );
  }
}

