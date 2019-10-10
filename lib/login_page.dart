import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/join_create_page.dart';
import 'package:ishallsealtheheavens/logic/login_authProvider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Container();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginButtons();
            case Status.Authenticated:
              return JoinCreatePage(user: user.user);
          }
          return Container();
        },
      ),
    );
  }
}

class LoginButtons extends StatelessWidget {
  final _auth = UserRepository.instance();

  @override
  Widget build(BuildContext context) {
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
                        _auth.signInWithFacebook();
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
                      onPressed: () => _auth.signInWithGoogle(),
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
