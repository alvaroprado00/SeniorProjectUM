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
        return 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        return 'Wrong email format.';
      } else {
        return e.code.toString();
      }
    }
  }

  /**
   * Method to add a User to Auth DB. If it suceeds then we call
   * a method to also create a user in the Firestore collection
   */
  static Future addUserToAuthAndFirestore(
      {required UserCustom u, required String password}) async {
    //Before creating the user in any DB we check if the userName is in use
    //Because if you dont check that you will end up creating a user in
    //Auth with no corresponding user in Firestore

    bool usernameInUse = await userNameExists(username: u.username);
    if (usernameInUse) {
      return 'Username already in use';
    }

    //First we upload the user in Auth DB
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: u.email,
        password: password,
      );

      //If we succeed in creating the user in the Auth DB, then we create the entry for the other info in the separate collection
      // That separate collection is were we will have our custom info of the user

      return addUserToFireStore(userCustom: u, userId: userCredential.user!.uid)
          .then((value) {
        return value;
      }).catchError((error) {
        print('Adding user to Firestore error');
        throw Exception('Adding user to Firestore error');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email format.';
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
      {required UserCustom userCustom, required String userId}) async {
    // Call the user's CollectionReference
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);

    //Access specific entry and set info
    return users.doc(userId).set(userCustom.toJson()).then((value) {
      print("User created");
      return true;
    }).catchError((error) {
      print("ERROR when persisting user in collection");
      return false;
    });
  }

  /**
   * Method to check if a username provided as param exists in the collection
   */
  static Future userNameExists({required String username}) {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection(userCollectionName);

    return usersRef.get().then((querySnapshot) {
      for (int i = 0; i < querySnapshot.size; i++) {
        //For each document in the questions collection I create a UserCustom
        Map<String, dynamic> json =
            querySnapshot.docs[i].data() as Map<String, dynamic>;

        if (json['username'].toLowerCase() == username.toLowerCase()) {
          return true;
        }
      }
      return false;
    }).catchError((error) {
      print('Error checking if username exists');
      throw Exception('Error checking if username exists.');
    });
  }

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
      throw Exception('Error getting active user.');
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

  /**
   * Method to get a List with all the users in the Database
   */
  static Future getAllUsers() {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection(userCollectionName);

    List<UserCustom> users = [];

    return usersRef.get().then((querySnapshot) {
      for (int i = 0; i < querySnapshot.size; i++) {
        //For each document in the questions collection I create a UserCustom
        Map<String, dynamic> json =
            querySnapshot.docs[i].data() as Map<String, dynamic>;
        users.add(UserCustom.fromJson(json));
      }
      return users;
    }).catchError((error) {
      print('Failed to get users');
      throw Exception('Error getting list of users.');
    });
  }

  /**
   * Method to update the password of the user in
   * FireBase Auth. It tries not to make the user identify
   * again
   */
  static Future updatePassword(
      {required String currentPassword, required String newPassword}) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    return user.reauthenticateWithCredential(cred).then((value) {
      return user.updatePassword(newPassword).then((_) {
        print('Password changed for active user');
        return true;
      }).catchError((error) {
        //Since I have just reauthenticated the user the
        //only possible error ir weak password
        print('Error when updating password');
        return false;
      });
    }).catchError((err) {
      print('Wrong password provided for update');
      throw Exception('Wrong password provided for update');
    });
  }

  /**
   * Method to sign out the active user
   */
  static Future signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'Signed out';
    } on FirebaseAuthException catch (e) {
      print('Error in the sign out');
      return 'Error when signing out.';
    }
  }

/**
 * Method to delete the account of the active user
 */
  static Future deleteActiveUser() async {
    try {
      await deleteUserFromFirestore(
          userID: FirebaseAuth.instance.currentUser!.uid);
      await FirebaseAuth.instance.currentUser!.delete();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
        return 'User must reauthenticate before';
      }
    } on Exception catch (e) {
      print('Error deleting account');
      return 'Error deleting the account';
    }
  }

  /**
   * Method to delete user from the user collection
   */
  static Future deleteUserFromFirestore({required String userID}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);
    return users.doc(userID).delete();
  }

  /**
   * Method to update any field in the user
   */
  static Future updateSimpleUserField(
      {required String nameOfField, required dynamic field}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);

    //I get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Access specific entry and set info
    return users.doc(uidOfActiveUser).update({
      nameOfField: field,
    }).then((value) {
      print("Updated field ${nameOfField}");
      return true;
    }).catchError((error) {
      print("Error updating field ${nameOfField}");
      return false;
    });
  }

  /**
   * Method to update the username. Since we have to check if it already
   * exists, I made a separate method
   */
  static Future updateUsername({required String newUsername}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);

    bool exists = await userNameExists(username: newUsername);

    if (exists) {
      return 'Username already exists';
    }

    //I get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Access specific entry and set info
    return users.doc(uidOfActiveUser).update({
      'username': newUsername,
    }).then((value) {
      print("Updated username");
      return true;
    }).catchError((error) {
      print("Error updating username");
      return false;
    });
  }

  /**
   * Method to upload a list of complex fields in the json of the
   * user in the Firebase DB. For More info see method
   * updateComplexUserField
   */
  static Future updateComplexListUserField(
      {required String nameOfField, required dynamic field}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);

    //I get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Access specific entry and set info
    return users.doc(uidOfActiveUser).update({
      nameOfField: field.map((e) => e.toJson()).toList(),
    }).then((value) {
      print("Updated field ${nameOfField}");
      return true;
    }).catchError((error) {
      print("Error updating field ${nameOfField}");
      return false;
    });
  }

  static Future updateComplexUserField(
      {required String nameOfField, required dynamic field}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(userCollectionName);

    //I get the id of the active user
    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    //Access specific entry and set info
    return users.doc(uidOfActiveUser).update({
      nameOfField: field.toJson(),
    }).then((value) {
      print("Updated field ${nameOfField}");
      return true;
    }).catchError((error) {
      print("Error updating field ${nameOfField}");
      return false;
    });
  }

  static Future addGroupCodeToUser({required List<String> groupCode}) async {
    CollectionReference users =
        await FirebaseFirestore.instance.collection(userCollectionName);

    String uidOfActiveUser = FirebaseAuth.instance.currentUser!.uid;

    return users
        .doc(uidOfActiveUser)
        .update({"userGroups": FieldValue.arrayUnion(groupCode)});
  }

  static Future<UserCustom> getUserByUserName({required String userName}) {
    var user = FirebaseFirestore.instance
        .collection(userCollectionName)
        .where("username", isEqualTo: userName)
        .get()
        .then((value) {
      Map<String, dynamic> json = value.docs.single.data();

      return UserCustom.fromJson(json);
    }).catchError((error) {
      print('Failed to get User: ${error.toString()}');
      throw Exception('Error getting active user');
    });
    return user;
  }
}
