import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FaceBookLogin facebooklogin = FaceBookLogin();

class FaceBookLogin {

  bool isFBLoggedin = false;

//  void onLoginStatusChanged(bool isLoggedIn) {
//    setState(() {
//      this.isFBLoggedIn = isLoggedIn;
//    });
//  }

  void initiateFacebookLogin() async {
    var facebooklogin = FacebookLogin();
    var facebookLoginResult = await facebooklogin.logInWithReadPermissions(['email']);

    switch(facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print('Error');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelled By User');
        break;
      case FacebookLoginStatus.loggedIn:
        print('logged In');
//        onLoginStatusChanged(true);
    }
  }

  Future<void> facebookLogOut() async {
    FacebookLogin.channel.invokeMethod('logOut');
  }
}


