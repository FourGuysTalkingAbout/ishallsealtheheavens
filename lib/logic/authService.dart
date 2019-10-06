import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  const User({@required this.uid});
  final String uid;
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // private method to create `User` from `FirebaseUser`
  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    // map all `FirebaseUser` objects to `User`, using the `_userFromFirebase` method
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}