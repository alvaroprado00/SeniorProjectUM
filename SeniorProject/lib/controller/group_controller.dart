import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/globals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class GroupController {

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  // Future<bool> checkGroupCode(groupCode) async {
  //   var group = FirebaseFirestore.instance
  //       .collection("groupCollection")
  //       .doc(groupCode)
  //       .get();
  //   if() {
  //     return true;
  //   }
  //   else {
  //     return false;
  //   }
  // }

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

  static Future addCurrentUserToGroup({required String groupCode}) async {
    var group = await FirebaseFirestore
        .instance.collection("groupCollection").doc(groupCode);

    return group.update({"groupMembers": FieldValue.arrayUnion([activeUser!.username])});
  }
}