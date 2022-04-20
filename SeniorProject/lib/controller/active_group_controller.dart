import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/group_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'dart:io';
import '../globals.dart';

class ActiveGroupController extends GetxController {
  final groupCode = 'groupCode'.obs;
  final groupName = 'groupName'.obs;
  final groupAdmin = 'groupAdmin'.obs;
  final dateCreated = 'dateCreated'.obs;
  final groupMembers = <String>[].obs;
  final groupImageURL = 'groupImage'.obs;

  ActiveGroupController({
    required String inGroupCode,
    required String inGroupName,
    required String inGroupAdmin,
    required String inDateCreated,
    required List<String> inGroupMembers,
    required String inGroupImageURL,}) {

    this.groupCode.value = inGroupCode;
    this.groupName.value = inGroupName;
    this.groupAdmin.value = inGroupAdmin;
    this.dateCreated.value = inDateCreated;
    this.groupMembers.value = inGroupMembers;
    this.groupImageURL.value = inGroupImageURL;
  }

  addCurrentUserToGroup() async {
    String gc = this.groupCode.value.toString();
    var group = await FirebaseFirestore
        .instance.collection("groupCollection")
        .doc(gc)
        .update({"groupMembers": FieldValue.arrayUnion([activeUser!.username])});
    this.groupMembers.value.add(activeUser!.username);
    update();
  }

  updateGroupName({required String inGroupName}) async {
    bool nameExists = await GroupController.groupNameExists(groupCode: this.groupCode.value.toString(), groupName: inGroupName);
    if(nameExists) {
      print('User Name Already Exists');
      return false;
    }
    else {
      GroupController.updateSingleGroupField(
        groupCode: this.groupCode.value.toString(), 
        groupField: 'groupName', 
        fieldValue: inGroupName,
      );
      this.groupName.value = inGroupName;
      update();
      return true;
    }
  }

  updateGroupImage({required File groupImage}) async {
    String newImageURL = await GroupController.uploadImage(this.groupCode.value.toString(), groupImage);
    GroupController.updateSingleGroupField(
      groupCode: this.groupCode.value.toString(),
      groupField: 'groupImageURL',
      fieldValue: newImageURL,
    );
    this.groupImageURL.value = newImageURL;
    update();
  }

  removeCurrentUserFromGroup() {
    ActiveUserController activeUserController = Get.find<ActiveUserController>();
    this.groupMembers.value.remove(activeUser!.username);
    GroupController.removeCurrentUserFromGroup(groupCode: groupCode.value.toString());
    activeUserController.removeUserFromGroup(groupCode: groupCode.value.toString());
    activeUserController.update();
    update();
  }

}