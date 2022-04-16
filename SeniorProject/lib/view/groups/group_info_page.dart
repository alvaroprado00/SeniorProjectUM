import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/groups/group_edit_page.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controller/group_controller.dart';
import '../../globals.dart';
import '../../model/group.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';

class GroupInfo extends StatelessWidget {
  GroupInfo({Key? key, required this.groupSnapshot}) : super(key: key);

  static final String routeName = "/GroupInfo";
  final Group groupSnapshot;
  final GroupController _groupController = new GroupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: getBackButton(context: context),
        title: Text(
          groupSnapshot.groupName,
          style: getHeadingStyleBlue(),
        ),
        centerTitle: true,
        actions: [
          groupSnapshot.groupAdmin == activeUser!.username ? Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroup(groupSnapshot: groupSnapshot,)));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                elevation: MaterialStateProperty.all<double>(0.0),
              ),
              child: Icon(CupertinoIcons.pencil_circle, color: secondaryColor,size: widthOfScreen * 0.1),
            ),
          ) : SizedBox(width: 0.01,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.group,
                    color: secondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 34.0),
                    child: Text(
                      groupSnapshot.groupMembers.length > 1 ? "${groupSnapshot.groupMembers.length.toString()} Members": "${groupSnapshot.groupMembers.length.toString()} Member",
                      style: const TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: StreamBuilder(
                stream: _groupController.getGroupByCode(groupSnapshot.groupCode),
                builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(
                      child: CircularProgressIndicator(color: primaryColor,),
                    );
                  }
                  else {
                    Group currentGroup = Group.fromJson(
                        snapshot.data!.data() as Map<String, dynamic>);
                    return GroupMembers(groupSnapshot: currentGroup);
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Group Code',
                    style: TextStyle(
                      fontSize: 22,
                      color: primaryColor,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
            GroupCode(groupCode: groupSnapshot.groupCode),
            groupSnapshot.groupAdmin == activeUser!.username ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 50.0),
              child: SizedBox(
                height: 50.0,
                width: 384.0,
                child: ElevatedButton(
                  onPressed: () {
                    GroupController.deleteGroup(groupCode: groupSnapshot.groupCode)
                        .then((value) {
                        Navigator.of(context).pop(context);
                    });
                  },
                  child: Text('Delete Group', style: getNormalTextStyleWhite(),),
                  style: blueButtonStyle,
                ),
              ),
            ) : groupSnapshot.groupMembers.length > 1 ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 50.0),
              child: SizedBox(
                height: 50.0,
                width: 384.0,
                child: ElevatedButton(
                  onPressed: () {
                      GroupController.removeCurrentUserFromGroup(groupCode: groupSnapshot.groupCode)
                          .then((value) {
                            Navigator.of(context).pop(context);
                      });
                  },
                  child: Text('Leave Group', style: getNormalTextStyleWhite(),),
                  style: blueButtonStyle,
                ),
              ),
            ) : SizedBox(height: 0.01,),
          ],
        ),
      ),
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
        return MemberTile(userName: memberList[index], groupAdmin: groupSnapshot.groupAdmin,);
      },
    );
  }
}


class MemberTile extends StatelessWidget {
  const MemberTile({Key? key, required this.userName, required this.groupAdmin}) : super(key: key);

  final String userName;
  final String groupAdmin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserController.getUserByUserName(userName: userName),
      builder: (context, AsyncSnapshot<UserCustom> groupMember) {
        if(!groupMember.hasData) {
          return Container(child: CircularProgressIndicator(),);
        }
        return ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          leading: Avatar(
            nameOfAvatar: groupMember.data!.profilePictureActive,
            size: widthOfScreen * 0.11,
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              groupMember.data!.username,
              style: getNormalTextStyleBlueBold(),
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 groupAdmin == userName ? Text(
                  "Admin",
                  style: getNormalTextStyleYellowBold(),
                )
                    : SizedBox(width: 0.01,height: 0.01,),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Level ${groupMember.data!.level.levelNumber.toString()}",
                    style: getNormalTextStyleBlue(),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class GroupCode extends StatelessWidget {
  const GroupCode({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: groupCode)).then((_){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Group Code copied to clipboard!',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
              backgroundColor: secondaryColor,
            )
            );
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.lock,
                color: secondaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  groupCode,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 36,
                  ),
                ),
              ),
              const Icon(
                Icons.copy,
                color: secondaryColor,
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFD5D5D5)),
        ),
      );
  }
}


