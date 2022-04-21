import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/groups/group_edit_page.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/active_group_controller.dart';
import '../../controller/group_controller.dart';
import '../../globals.dart';
import '../../model/group.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';

class GroupInfo extends StatelessWidget {
  GroupInfo({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;
  final GroupController _groupController = new GroupController();

  @override
  Widget build(BuildContext context) {
    final ActiveGroupController activeGroupController =
        Get.find<ActiveGroupController>(tag: groupCode);

    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: getBackButton(context: context),
            title: Text(
              activeGroupController.groupName.value.toString(),
              style: getHeadingStyleBlue(),
            ),
            centerTitle: true,
            actions: [
              activeGroupController.groupAdmin.value.toString() ==
                      activeUser!.username
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditGroup(
                                        groupCode: groupCode,
                                      )));
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              const CircleBorder()),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(40, 40)),
                          elevation: MaterialStateProperty.all<double>(0.0),
                        ),
                        child: Icon(CupertinoIcons.pencil_circle,
                            color: secondaryColor, size: 32),
                      ),
                    )
                  : SizedBox(
                      width: 0.01,
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 24,
                      left: 0.03 * widthOfScreen,
                      right: 0.03 * widthOfScreen),
                  child: SubtitleDivider(subtitle: 'Members'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: StreamBuilder(
                    stream: _groupController.getGroupByCode(
                        activeGroupController.groupCode.value.toString()),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(
                          child: Container(
                              child: CircularProgressIndicator(
                            color: primaryColor,
                          )),
                        );
                      } else {
                        Group currentGroup = Group.fromJson(
                            snapshot.data!.data() as Map<String, dynamic>);
                        return GroupMembers(groupSnapshot: currentGroup);
                      }
                    },
                  ),
                ),
                Text(
                    activeGroupController.groupMembers.value.length > 1
                        ? "${activeGroupController.groupMembers.value.length.toString()} Members"
                        : "${activeGroupController.groupMembers.value.length.toString()} Member",
                    style: getSmallTextStyleGrey()),
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.03 * widthOfScreen,
                      right: 0.03 * widthOfScreen,
                      top: 16),
                  child: SubtitleDivider(
                    subtitle: 'Group Code',
                  ),
                ),
                GroupCode(groupCode: groupCode),
                activeGroupController.groupAdmin.value.toString() ==
                        activeUser!.username
                    ? Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, left: 16.0, right: 16.0, top: 50.0),
                        child: SizedBox(
                          height: 50.0,
                          width: 384.0,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DeleteGroup(groupCode: groupCode),
                              );
                            },
                            child: Text(
                              'Delete Group',
                              style: getNormalTextStyleWhite(),
                            ),
                            style: blueButtonStyle,
                          ),
                        ),
                      )
                    : activeGroupController.groupMembers.value.length > 1
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0,
                                left: 16.0,
                                right: 16.0,
                                top: 50.0),
                            child: SizedBox(
                              height: 50.0,
                              width: 384.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        LeaveGroup(
                                            activeGroupController:
                                                activeGroupController),
                                  );
                                },
                                child: Text(
                                  'Leave Group',
                                  style: getNormalTextStyleWhite(),
                                ),
                                style: blueButtonStyle,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 0.01,
                          ),
              ],
            ),
          ),
        ));
  }
}

class DeleteGroup extends StatelessWidget {
  const DeleteGroup({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure?",
        style: getSubheadingStyleBlue(),
      ),
      content: Text(
        "All data will be lost.",
        style: getNormalTextStyleBlue(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          child: Text("No", style: getNormalTextStyleBlue()),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            GroupController.deleteGroup(groupCode: groupCode);
            Navigator.of(context).pop();
          },
          child: Text("Yes", style: getNormalTextStyleYellow()),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
      ],
      backgroundColor: tertiaryColor,
    );
  }
}

class LeaveGroup extends StatelessWidget {
  const LeaveGroup({Key? key, required this.activeGroupController})
      : super(key: key);

  final ActiveGroupController activeGroupController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        "Are you sure? ",
        style: getSubheadingStyleBlue(),
      ),
      content: Text(
        "You will no longer be able to see group members and group notifications.",
        style: getNormalTextStyleBlue(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          child: Text("No", style: getNormalTextStyleBlue()),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            activeGroupController.removeCurrentUserFromGroup();
            if (Get.isRegistered<ActiveGroupController>(
                tag: activeGroupController.groupCode.toString())) {
              Get.find<ActiveGroupController>(
                      tag: activeGroupController.groupCode.toString())
                  .dispose();
            }
            Navigator.of(context).pop();
          },
          child: Text("Yes", style: getNormalTextStyleYellow()),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
      ],
      backgroundColor: tertiaryColor,
    );
  }
}

class GroupMembers extends StatelessWidget {
  GroupMembers({Key? key, required this.groupSnapshot}) : super(key: key);

  final Group groupSnapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groupSnapshot.groupMembers.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        List<String> memberList = groupSnapshot.groupMembers.toList();
        return MemberTile(
          userName: memberList[index],
          groupAdmin: groupSnapshot.groupAdmin,
        );
      },
    );
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile({Key? key, required this.userName, required this.groupAdmin})
      : super(key: key);

  final String userName;
  final String groupAdmin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserController.getUserByUserName(userName: userName),
        builder: (context, AsyncSnapshot<UserCustom> groupMember) {
          if (!groupMember.hasData) {
            return ListTile(
                title: Container(
              width: widthOfScreen * 0.1,
              child: CircularProgressIndicator(),
            ));
          }
          return ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            leading: Avatar(
              nameOfAvatar: groupMember.data!.profilePictureActive,
              size: widthOfScreen * 0.11,
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(groupMember.data!.username,
                  style: groupAdmin == userName
                      ? getNormalTextStyleYellowBold()
                      : getNormalTextStyleBlue()),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: secondaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.star_fill,
                            color: secondaryColor,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${groupMember.data!.level.levelNumber.toString()}',
                              style: getSubheadingStyleYellow(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class GroupCode extends StatelessWidget {
  const GroupCode({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: groupCode)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Group Code copied to clipboard!',
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
              ),
            ),
            backgroundColor: secondaryColor,
          ));
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.lock,
              color: secondaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(groupCode, style: getSubheadingStyleBlue()),
            ),
            const Icon(
              Icons.copy,
              color: secondaryColor,
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0))),
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFD5D5D5)),
      ),
    );
  }
}
