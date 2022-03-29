import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GroupController {

  bool checkGroupCode(groupCode) {
    var group = FirebaseFirestore.instance
        .collection("groupCollection")
        .doc(groupCode).id;
    if(group == groupCode) {
      return true;
    }
    else {
      return false;
    }
  }

  Future addGroup(groupMap, groupCode) async {
    return FirebaseFirestore.instance
      .collection("groupCollection")
      .doc(groupCode)
      .set(groupMap);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getGroupByCode(groupCode) {
    return FirebaseFirestore.instance
        .collection("groupCollection")
        .doc(groupCode)
        .snapshots();
  }

  Future<String> uploadImage(String groupCode ,File imageFile) async {
    String fileName = imageFile.path.toString().split('/').last;
    var ref = FirebaseStorage.instance.ref()
        .child("groupImages")
        .child("$groupCode")
        .child("$fileName");

    await ref.putFile(imageFile);

    return await ref.getDownloadURL();
  }
}