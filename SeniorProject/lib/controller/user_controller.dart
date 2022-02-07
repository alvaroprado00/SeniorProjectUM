import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserController {

  Future loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  Future addUserToAuthAndFirestore(
      {required UserCustom u, required String password}) async {

    //First we upload the user in Auth DB
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: u.email,
        password: password,
      );

      //If we succeed in creating the user in the Auth DB, then we create the entry for the other info in the separate collection
      // That separate collection is were we will have our custom info of the user

      addUserToFireStore(userCustom: u, userId: userCredential.user!.uid);

      return u;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future addUserToFireStore(
      {required UserCustom userCustom, required String userId}) {
    // Call the user's CollectionReference
    CollectionReference users =
    FirebaseFirestore.instance.collection(userCollectionName);
    //Access specific entry and set info
    return users.doc(userId).set({
      'userName': userCustom.username,
      'email': userCustom.email,
    }).then((value) {
      print("USER CREATED");
    }).catchError((error) {
      print("ERROR when persisting user in collection");
    });

  }

  static Future getActiveUser() async {
    CollectionReference users =
    FirebaseFirestore.instance.collection(userCollectionName);

    //I can get the uid of the active user with the following method

    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;
    await users.doc(uidOfActiveUser).get().then((snapshot){

      Map<String, dynamic> json = snapshot.data as Map<String, dynamic>;
      return UserCustom.fromJson(json);
    });

  }
}





