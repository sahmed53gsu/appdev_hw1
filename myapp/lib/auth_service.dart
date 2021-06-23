import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'main.dart';

class AuthService {
  // Authentication method
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('go homepage');
          return HomePage();
        } else {
          print('go login page');
          return LoginPage();
        }
      },
    );
  }

  //Signout
  signOut() {
    FirebaseAuth.instance.signOut();
    //signOutGoogle();
  }

  //Sign in
  signIn(email, password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print('Signed in');
    }).catchError((e) {
      print(e);
    });
  }

  //signup
  createNewUser(fname, lname, email, password, {role = 'customer'}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      addUser(fname, lname, role);
      print('Registered');
    }).catchError((e) {
      print(e);
    });
  }

  //if admin
  /*
  authorizeAccess(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser!.uid)
        .get()
        .then((docs) {
      if (docs.data()['role'] == 'admin') {
        print('yomama');
        return true;
      } else {
        print('yeoyeo');
        return false;
      }
    });
  } */

  authorizeAccess() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (FirebaseAuth.instance.currentUser!.uid ==
        'KRQEAXmFZWezETQYtUEtfMOKWrE3') {
      return true;
    }
    return false;
  }

  postUp(message) {
    postMessage(message);
  }

  /*
  authorizeAccess() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((ds) {
      print('yomama');
      if (ds.data()!["role"] == 'admin') {
        return true;
      } else {
        return false;
      }
    });
  } */
}

Future<void> addUser(fname, lname, role) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // Call the user's CollectionReference to add a new user
  return users
      .add({
        'first_name': fname,
        'last_name': lname,
        'role': role,
        'dtime': DateTime.now(),
        'uid': FirebaseAuth.instance.currentUser!.uid
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<void> postMessage(message) async {
  CollectionReference users = FirebaseFirestore.instance.collection('posts');
  // Call the user's CollectionReference to add a new user
  return users
      .add({
        'message': message,
        'dtime': DateTime.now(),
        'uid': FirebaseAuth.instance.currentUser!.uid
      })
      .then((value) => print("message posted"))
      .catchError((error) => print("Failed to add user: $error"));
}

// ------------------------------------------ Google Sign in --------------------------------------
final FirebaseAuth _auth = FirebaseAuth.instance;

var authSignedIn;
var uid;
var userEmail;

final GoogleSignIn googleSignIn = GoogleSignIn();

var name;
var imageUrl;

Future<String?> signInWithGoogle() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User? user = userCredential.user;

  if (user != null) {
    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    uid = user.uid;
    name = user.displayName;
    userEmail = user.email!;
    imageUrl = user.photoURL;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User? currentUser = _auth.currentUser;
    assert(user.uid == currentUser!.uid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);

    return 'Google sign in successful, User UID: ${user.uid}';
  }

  return null;
}

signOutGoogle() async {
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  print("User signed out of Google account");
}
