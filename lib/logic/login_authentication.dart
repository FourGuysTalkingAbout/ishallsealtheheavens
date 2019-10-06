import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';



class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser user) {
      if (user != null) {
        return _db
            .collection('users')
            .document(user.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({}); // empty object ???? -AB
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    // Start
    loading.add(true);

    //Step 1 Login with google. shows google's native log in screen and provide idToken and accessToken.
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //Step 2 Login to FireBase. user is logged into google. but not firebase. pass the tokens to login to firebase.
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    updateUserData(user);
    print('Signed in ' + user.displayName);

    loading.add(false);
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData(
      {
        'name':user.displayName,
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'lastSeen': DateTime.now(),
      },
      merge: true,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); //is this needed?
    await _facebookLogin.logOut();

    print('google/facebook/auth all IN one signout');
  }

  ////////////FACEBOOK LOGIN//////////////////////////

  Future<FirebaseUser> signInWithFacebook() async {
    final FacebookLoginResult fbLoginResult = await _facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    FacebookAccessToken fbToken = fbLoginResult.accessToken;

    final AuthCredential fbCredential =
        FacebookAuthProvider.getCredential(accessToken: fbToken.token);
    final FirebaseUser user = (await _auth.signInWithCredential(fbCredential)).user;
    updateUserData(user);
    return user;
  }

  Future<void> facebookLogOut() async {
    await _auth.signOut();
    await _facebookLogin.logOut(); //is this needed?
    print('fb logout');
  }


  /////////////////////SIGN UP/LOGIN WITH EMAIL/////////////
  Future<FirebaseUser> signInWithEmail(String email, String password) async {
     FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
     assert(user != null);
     assert(await user.getIdToken() != null);
     final FirebaseUser currentUser = await _auth.currentUser();
     assert(user.uid == currentUser.uid);

     updateUserData(user);
     print('Signed in ' + user.displayName);
     return user;
  }

  //TODO create a displayname for when they signup via email
  Future<FirebaseUser> signUpWithEmail(String email, String password) async {
    try{
      FirebaseUser user = (await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      updateUserData(user);
      print('Signed in ' + user.displayName);
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
final AuthService authService = AuthService();