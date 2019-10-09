import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated  }

class UserRepository with ChangeNotifier {

  final FacebookLogin _facebookLogin = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); //is this needed?
    await _facebookLogin.logOut();
    _user = null;
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null ) {
      _status = Status.Unauthenticated;
    }else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      updateUserData(user);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
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

  ////////////FACEBOOK LOGIN//////////////////////////

  Future<bool> signInWithFacebook() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final FacebookLoginResult fbLoginResult = await _facebookLogin
          .logInWithReadPermissions(['email', 'public_profile']);
      FacebookAccessToken fbToken = fbLoginResult.accessToken;

      final AuthCredential fbCredential =
      FacebookAuthProvider.getCredential(accessToken: fbToken.token);
      final FirebaseUser user = (await _auth.signInWithCredential(fbCredential))
          .user;
      updateUserData(user);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> facebookLogOut() async {
    await _auth.signOut();
    await _facebookLogin.logOut(); //is this needed?
    print('fb logout');
  }


  /////////////////////SIGN UP/LOGIN WITH EMAIL/////////////
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

    FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    updateUserData(user);
    return true;

    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //TODO create a displayname for when they signup via email
  Future<bool> registerWithEmail(String email, String password) async {
    try{
      _status = Status.Authenticating;
      notifyListeners();
      FirebaseUser user = (await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      updateUserData(user);
      print('Signed in ' + user.displayName);
      return true;
    } catch (error) {
      print(error);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }
}

final UserRepository authService = UserRepository.instance();