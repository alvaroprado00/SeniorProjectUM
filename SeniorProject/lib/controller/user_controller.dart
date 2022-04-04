import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  /**
   * Method to login into Auth DB provided an email and a Password
   * If the credentials are OK it returns the user credentials and changes
   * the state of the user to loggedIn. In case the credentials are KO returns
   * a String with the reason of the error
   */
  static Future loginWithEmailAndPassword(
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

  /**
   * Method to add a User to Auth DB. If it suceeds then we call
   * a method to also create a user in the Firestore collection
   */
  static Future addUserToAuthAndFirestore(
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

      return addUserToFireStore(
          userCustom: u, userId: userCredential.user!.uid);
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

  /**
   * Method to add a user to the userCollection in Firestore.
   * The document created will be named with the userId from the AuthDB
   */
  static Future<dynamic> addUserToFireStore(
      {required UserCustom userCustom, required String userId}) {
    // Call the user's CollectionReference
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);
    //Access specific entry and set info
    return users.doc(userId).set(userCustom.toJson()).then((value) {
      print("User created/updated");
      return true;
    }).catchError((error) {
      print("ERROR when persisting user in collection");
      return false;
    });
  }

  /**
   * This method returns the user that is active in the app in case there is
   * one
   */
  static Future getActiveUser() {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);

    //I can get the uid of the active user with the following method

    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;
    return users.doc(uidOfActiveUser).get().then((snapshot) {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

      return UserCustom.fromJson(json);
    }).catchError((error) {
      print('Failed to get User: ${error.toString()}');
      throw Exception('Error getting active user');
    });
  }

  static Future getUsername() async {
    try {
      UserCustom u = await getActiveUser();
      return u.username;
    } catch (error) {
      throw Exception('');
    }
  }

  static Future updateActiveUser() {
    //We get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Now we update it in the Firestore DB

    return addUserToFireStore(userCustom: activeUser!, userId: uidOfActiveUser);
  }

  static Future updatePassword({required String currentPassword, required String newPassword}) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    return user.reauthenticateWithCredential(cred).then((value) {
      return user.updatePassword(newPassword).then((_) {
        print('Password changed for active user');
        return true;
      }).catchError((error) {
        print('Error when updating password');
        return false;
      });
    }).catchError((err) {

    });}

  /**
   * Method to sign out the active user
   */
  static Future signOutUser() async {
    try{
      await FirebaseAuth.instance.signOut();
      return 'Signed out';

    } on FirebaseAuthException catch(e){
      print('Error in the sign out');
      return 'Error in the sign out';
    }

  }

/**
 * Method to delete the account of the active user
 */
static Future deleteActiveUser() async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
    return 'Success';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      print('The user must reauthenticate before this operation can be executed.');
      return 'User must reauthenticate before';
    }
  }
}


  /**
   * Method to update any field in the user
   */
  static Future updateSimpleUserField({required String nameOfField, required dynamic field}){
  CollectionReference users =
  FirebaseFirestore.instance.collection(userCollectionName);

  //I get the id of the active user
  String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

  //Access specific entry and set info
  return users.doc(uidOfActiveUser).update({
    nameOfField:field,
  }).then((value) {
    print("Updated field ${nameOfField}");
    return true;
  }).catchError((error) {
    print("Error updating field ${nameOfField}");
    return false;
  });

  }

  

  static Future updateComplexListUserField({required String nameOfField, required dynamic field}){
    CollectionReference users =
    FirebaseFirestore.instance.collection(userCollectionName);

    //I get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Access specific entry and set info
    return users.doc(uidOfActiveUser).update({
      nameOfField:field.map((e) => e.toJson()).toList(),
    }).then((value) {
      print("Updated field ${nameOfField}");
      return true;
    }).catchError((error) {
      print("Error updating field ${nameOfField}");
      return false;
    });

  }

  static Future updateComplexUserField({required String nameOfField, required dynamic field}){
    CollectionReference users =
    FirebaseFirestore.instance.collection(userCollectionName);

    //I get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Access specific entry and set info
    return users.doc(uidOfActiveUser).update({
      nameOfField:field.toJson(),
    }).then((value) {
      print("Updated field ${nameOfField}");
      return true;
    }).catchError((error) {
      print("Error updating field ${nameOfField}");
      return false;
    });

  }

  static Future addGroupCodeToUser({required List<String> groupCode}) async {
    CollectionReference users = await FirebaseFirestore
        .instance.collection(userCollectionName);

    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    return users.doc(uidOfActiveUser).update({"userGroups": FieldValue.arrayUnion(groupCode)});
  }


}
