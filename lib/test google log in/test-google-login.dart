import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'DetailedScreen.dart';

final TestingGoogleSignIn blahblah = TestingGoogleSignIn();
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;
final FacebookLogin facebookLogin = FacebookLogin();

class TestingGoogleSignIn extends StatefulWidget {
  @override
  _TestingGoogleSignInState createState() => _TestingGoogleSignInState();
}

class _TestingGoogleSignInState extends State<TestingGoogleSignIn> {
  bool isLoggedInFacebook;
  bool isLoggedInGoogle;
  GoogleSignInAccount _currentUser;
  bool _success;
  String _userID;
  bool isLoggedIn = false;

//  void checkIfLoggedIn(bool loggedIn) {
//    if(isLoggedInFacebook != true || isLoggedInGoogle != true ) {
//      return
//    }
//  }

//  void onLoginStatusChanged(bool isLoggedIn) {
//    setState(() {
//      this.isLoggedIn = isLoggedIn;
//    });
//  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });

//    _googleSignIn.signInSilently(); // Force the user to interactively sign in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Center(
        child: ListBody(children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(identity: _currentUser),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('JoinCreate'),
            color: Colors.white,
            textColor: Colors.black,
            child: Text('Join or Create an Instance'),
          ),
          MaterialButton(
            onPressed: () => _handleSignOut(),
            color: Colors.white,
            textColor: Colors.black,
            child: Text('Sign out'),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                      ? 'Successfully signed in, uid: ' + _userID
                      : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          )
        ]),
      );
    } else {
      return Center(
        child: ListBody(children: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('LoginEmail'),
            color: Color(0xff757575),
            textColor: Color(0xffFFC107),
            child: Text('Login with Email'),
          ),
          MaterialButton(
            onPressed: () =>_signInWithFacebook(),
            color: Color(0xff3b5998),
            textColor: Colors.white,
            child: Text('Login with Facebook'),
          ),
          MaterialButton(
            onPressed: () => _signInWithGoogle(),
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
        ]),
      );
    }
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FirebaseUser user = (await _auth.signInWithCredential(
        credential)); //(await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    updateUserData(user);

  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData(
      {
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'lastSeen': DateTime.now(),
      },
      merge: true,
    );
  }
//
//  Future<void> _handleSignIn() async {
//    try {
//      await _googleSignIn.signIn();
//    } catch (error) {
//      print(error);
//    }
//  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    _googleSignIn.signOut();
  }


  ////////////FACEBOOK LOGIN//////////////////////////

  Future<FirebaseUser> firebaseAuthWithFacebook({@required FacebookAccessToken token}) async {

    AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: token.token);
    FirebaseUser firebaseUser = await _auth.signInWithCredential(credential);
    return firebaseUser;
  }


  Future<FirebaseUser> _signInWithFacebook()  async {
    final FacebookLoginResult fbLoginResult = await facebookLogin.logInWithReadPermissions(['email', 'public_profile']);
    FacebookAccessToken fbToken = fbLoginResult.accessToken;

    switch(fbLoginResult.status) {
      case FacebookLoginStatus.error:
        print('Error');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelled By User');
        break;
      case FacebookLoginStatus.loggedIn:
        print('Facebooked logged In');
        final AuthCredential fbCredential = FacebookAuthProvider.getCredential(
            accessToken: fbToken.token);
        final FirebaseUser user = await _auth.signInWithCredential(fbCredential);
        updateUserData(user);

        ProviderDetails userInfo = new ProviderDetails(
            user.providerId, user.uid, user.displayName, user.photoUrl, user.email);

        List<ProviderDetails> providerData = new List<ProviderDetails>();
        providerData.add(userInfo);

        UserInfoDetails userInfoDetails = new UserInfoDetails(
            user.providerId,
            user.uid,
            user.displayName,
            user.photoUrl,
            user.email,
            user.isAnonymous,
            user.isEmailVerified,
            providerData);
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new DetailedScreen(detailsUser: userInfoDetails),
          ),
        );
    }
//    return user;
  }



//
//  Future<void> initiateFacebookLogin() async {
//    var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
//
//    switch(facebookLoginResult.status) {
//      case FacebookLoginStatus.error:
//        print('Error');
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        print('cancelled By User');
//        break;
//      case FacebookLoginStatus.loggedIn:
//        print('Facebooked logged In');
////        onLoginStatusChanged(true);
//        isLoggedInFacebook = true;
//    }
//  }

  Future<void> facebookLogOut() async {
    await facebookLogin.logOut();
    print ('fb logout');
  }
}

class UserInfoDetails {
  UserInfoDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);

  /// The provider identifier.
  final String providerId;

  /// The provider’s user ID for the user.
  final String uid;

  /// The name of the user.
  final String displayName;

  /// The URL of the user’s profile photo.
  final String photoUrl;

  /// The user’s email address.
  final String email;

  // Check anonymous
  final bool isAnonymous;

  //Check if email is verified
  final bool isEmailVerified;

  //Provider Data
  final List<ProviderDetails> providerData;
}

class ProviderDetails {
  final String providerId;

  final String uid;

  final String displayName;

  final String photoUrl;

  final String email;

  ProviderDetails(
      this.providerId, this.uid, this.displayName, this.photoUrl, this.email);
}