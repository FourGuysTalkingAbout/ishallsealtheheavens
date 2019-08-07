import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'logic/login_authentication.dart';
import 'logic/fb_login.dart';

class LoginPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isFBLoggedIn = false;
  bool triedCheckLoggedIn = false;

  void onFBLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isFBLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (triedCheckLoggedIn == false) {
      _checkLoggedIn();
    }

    return Scaffold(
      backgroundColor: const Color(0xff673AB7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 48,
                height: 128,
                child: Image(
                  image: AssetImage('images/icecreamcolour.png'),
                )),
            LoginButton(),
//            UserProfile(),
          ],
        ),
      ),
    );
  }

  Future _checkLoggedIn() async {
    GoogleSignInAccount googleuser = GoogleSignIn().currentUser;
    if (googleuser == null) {
      await authService.googleSignIn();
    } else if (FaceBookLogin().isFBLoggedin == false) {
      await authService.initiateFacebookLogin();
    } else
      return AfterLogIn();
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

class AfterLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  authService.initiateFacebookLogin();
                },
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
