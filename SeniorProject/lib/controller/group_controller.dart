import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/config/k_collection_names_firebase.dart';
import 'package:cyber/controller/active_group_controller.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/custom_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';

class GroupController {

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
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

  static Future<String> uploadImage(String groupCode ,File imageFile) async {
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

  static Future addNotification({required CustomNotification notif, required List<String> groupCodes}) async {
    for (String code in groupCodes) {
      FirebaseFirestore.instance
          .collection("groupCollection")
          .doc(code)
          .collection("groupNotifications")
          .add(notif.toJson());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGroupNotifications({required String groupCode}) {
    return FirebaseFirestore.instance
        .collection("groupCollection")
        .doc(groupCode)
        .collection("groupNotifications")
        .orderBy('dateSent', descending: true)
        .snapshots();
  }

  static initNotifications({required String groupCode}) {
    return FirebaseFirestore.instance
        .collection("groupCollection")
        .doc(groupCode)
        .collection("groupNotifications");
  }
  
  static Future removeCurrentUserFromGroup({required String groupCode}) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
      .collection(userCollectionName)
      .doc(uid)
      .update({"userGroups" : FieldValue.arrayRemove([groupCode])});
    return FirebaseFirestore.instance
        .collection("groupCollection")
        .doc(groupCode)
        .update({"groupMembers" : FieldValue.arrayRemove([activeUser!.username])});
  }

  static deleteGroup({required String groupCode}) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    ActiveUserController activeUserController = Get.find<ActiveUserController>();
    var users = FirebaseFirestore.instance
        .collection(userCollectionName);
    var group = FirebaseFirestore.instance
        .collection("groupCollection")
        .doc(groupCode);
    users.where('userGroups', arrayContains: groupCode).get().then((value) {
      for(DocumentSnapshot val in value.docs) {
        users.doc(val.id)
            .update({"userGroups" : FieldValue.arrayRemove([groupCode])});
      }
    });
    group.collection('groupNotifications').get().then((value) {
      for(DocumentSnapshot val in value.docs) {
        group.collection('groupNotifications').doc(val.id).delete();
      }
    });
    group.delete();
    if(Get.isRegistered<ActiveGroupController>(tag: groupCode)) {
      Get.find<ActiveGroupController>(tag: groupCode).dispose();
    }
    activeUserController.removeUserFromGroup(groupCode: groupCode);
    activeUserController.update();
  }

  static Future groupNameExists({required String groupCode, required String groupName}){
    CollectionReference groupRef =
    FirebaseFirestore.instance.collection("groupCollection");

    return groupRef.doc(groupCode).get().then((querySnapshot) {
      Map<String, dynamic> json = querySnapshot.data() as Map<String, dynamic>;
      if(json['groupName']==groupName){
        return true;
      }
      return false;

    }).catchError((error) {
      print('Error checking if username exists');
      throw Exception('Error checking if username exists');
    });
  }

  static Future updateGroupName(
      {required String groupCode, required String groupName}) async {
    CollectionReference groupRef =
    FirebaseFirestore.instance.collection("groupCollection");


    bool exists = await groupNameExists(groupCode: groupCode, groupName: groupName,);

    if(exists){
      return 'Username already exists';
    }

    //Access specific entry and set info
    return groupRef.doc(groupCode).update({
      'groupName': groupName,
    }).then((value) {
      print("Updated username");
      return true;
    }).catchError((error) {
      print("Error updating username");
      return false;
    });
  }

  static updateSingleGroupField({required String groupCode, required String groupField, required String fieldValue}) {
    CollectionReference groups =
    FirebaseFirestore.instance.collection("groupCollection");

    //Access specific entry and set info
    return groups.doc(groupCode).update({
      groupField: fieldValue,
    }).then((value) {
      print("Updated field ${groupField}");
      return true;
    }).catchError((error) {
      print("Error updating field ${groupField}");
      return false;
    });
  }

}