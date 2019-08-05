import 'package:flutter/material.dart';

import 'logic/login_authentication.dart';

class LoginPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff673AB7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginButton(),
//            UserProfile(),
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
          return ListBody(
            children: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pushNamed('JoinCreate'),
                color: Colors.white,
                textColor: Colors.black,
                child: Text('Join or Create an Instance'),
              ),
              MaterialButton(
                onPressed: () => authService.signOut(),
                color: Colors.white,
                textColor: Colors.black,
                child: Text('Sign out'),
              ),
            ],
          );
        } else {
          return ListBody(
            children: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pushNamed('LoginEmail'),
                color: Color(0xff757575),
                textColor: Color(0xffFFC107),
                child: Text('Login with Email'),
              ),
              MaterialButton(
                onPressed: () => {},
                color: Color(0xff3b5998),
                textColor: Colors.white,
                child: Text('Login with Facebook'),
              ),
              MaterialButton(
                onPressed: () => authService.googleSignIn(),
                color: Color(0xffdb3236),
                textColor: Colors.white,
                child: Text('Login with Google'),
              ),
              MaterialButton(
                  onPressed: () => {},
                  color: Color(0xff673AB7),
                  textColor: Color(0xffFFC107),
                  child: Container(
                    child: Text('No Account \n View Only'),
                  )),
            ],
          );
        }
      },
    );
  }
}

