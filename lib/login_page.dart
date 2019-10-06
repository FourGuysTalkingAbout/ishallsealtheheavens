import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/join_create_page.dart';
import 'logic/login_authentication.dart';

class LoginPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return LoginButton();
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override // if you setup listeners on a stream or an observable need to initialize the state  || ???????? -AldBas

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

class LoginButton extends StatefulWidget {
  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return JoinCreatePage();
        } else {
          return Scaffold(
            backgroundColor: const Color(0xff673AB7),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 48,
                      height: 128,
                      child: Image(
                        image: AssetImage('images/icecreamcolour.png'),
                      )),
                  ListBody(
                    children: <Widget>[
                      Center(
                        child: LoginButtonContainer(
                          child: MaterialButton(
                            elevation: 0.0,
                            onPressed: () =>
                                Navigator.of(context).pushNamed('LoginEmail'),
                            color: Color(0xff757575),
                            textColor: Color(0xffFFC107),
                            child: Text('Login with Email'),
                          ),
                        ),
                      ),
                      Center(
                        child: LoginButtonContainer(
                          child: MaterialButton(
                            elevation: 0.0,
                            onPressed: () {
                              authService.signInWithFacebook();
                            },
                            color: Color(0xff3b5998),
                            textColor: Colors.white,
                            child: Text('Login with Facebook'),
                          ),
                        ),
                      ),
                      Center(
                        child: LoginButtonContainer(
                          child: MaterialButton(
                            elevation: 0.0,
                            onPressed: () => authService.googleSignIn(),
                            color: Color(0xffdb3236),
                            textColor: Colors.white,
                            child: Text('Login with Google'),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          width: 151,
                          height: 40,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                              color: Color(0xffFFC107),
                            ),
                          ),
                          child: MaterialButton(
                            elevation: 0.0,
                            onPressed: () => {},
                            color: Color(0xff673AB7),
                            textColor: Color(0xffFFC107),
                            child: Text('No Account \n View Only'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class LoginButtonContainer extends Container {
  final Container container;

  LoginButtonContainer({this.container, Widget child}) : super(child: child);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      width: 213,
      height: 40,
      decoration: new BoxDecoration(
        border: new Border.all(
          color: Color(0xffFFC107),
        ),
      ),
      child: child,
    );
  }
}
