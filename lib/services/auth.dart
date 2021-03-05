import "package:firebase_auth/firebase_auth.dart";
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user obj based on FirebaseUser
  AuthUser _userFromFirebaseUser(User user) {
    //AuthUser
    //FirebaseUser => User
    return user != null ? AuthUser(uid: user.uid) : null; //AuthUser
  }

  // auth change user stream
  Stream<AuthUser> get user {
    //AuthUser
    return _auth
        .authStateChanges() //onAuthStateChanged
        .map((User user) => _userFromFirebaseUser(user)); //FirebaseUser => User
  }

  // sign in anon
  Future siginInAnon() async {
    try {
      /* AuthResult => UserCredential is OK!
      AuthResult result = await _auth.signInAnonymously();
      User user = result.user; //FirebaseUser => User
      */
      final User user = (await _auth.signInAnonymously()).user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      /*
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user; //FirebaseUser => User
      */
      final User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      /*
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user; //FirebaseUser => User
      */
      final User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      // create a new document  for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(email, 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sing out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
