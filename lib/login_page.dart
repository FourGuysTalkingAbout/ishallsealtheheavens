import 'package:flutter/material.dart';

import 'logic/login_authentication.dart';

class LoginPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginButton(),
            UserProfile(),
          ],
        ),
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override // if you setup listeners on a stream or an observable need to initialize the state
  initState() {
    super.initState();
    authService.profile.listen(
          (state) => setState(() => _profile = state),
    );
    authService.loading.listen(
          (state) => setState(() => _loading = state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Text(_profile.toString()),
        ),
      ],
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
          return MaterialButton(
//            onPressed: () => authService.signOut(),
            onPressed: () => Navigator.of(context).pushNamed('JoinCreate'),
            color: Colors.white,
            textColor: Colors.black,
            child: Text('Join or Create an Instance'),
          );
        } else {
          return MaterialButton(
            onPressed: () => authService.googleSignIn(),
            color: Colors.white,
            textColor: Colors.black,
            child: Text('Login with Google'),
          );
        }
      },
    );
  }
}
