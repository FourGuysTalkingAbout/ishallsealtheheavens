import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';



final AuthService authService = AuthService();

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;


  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);



    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({}); // empty object
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    updateUserData(user);
    print('Signed in' + user.displayName);

    loading.add(false);
    return user;
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

  void signOut() {
//    FacebookLogin.channel.invokeMethod('logOut');
    _auth.signOut();
  }

  ////////////FACEBOOK LOGIN//////////////////////////


  Future<void> initiateFacebookLogin() async {
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
        print('Facebooked logged In');
//        onLoginStatusChanged(true);
    }
  }
  Future<bool> isFBLoggedIn() async {
   FacebookLogin().currentAccessToken;
  }

  Future<void> facebookLogOut() async {
    FacebookLogin.channel.invokeMethod('logOut');
  }


}

