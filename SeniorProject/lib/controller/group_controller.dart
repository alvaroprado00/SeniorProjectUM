import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/user_custom.dart';

class GroupController {
  addGroup(groupMap, groupCode) async {
    return FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(groupCode)
      .set(groupMap)
      .catchError((e) {
        print(e);
      });
  }
}