import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/group_controller.dart';
import 'package:cyber/model/custom_notification.dart';
import 'package:cyber/view/groups/group_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/group.dart';
import '../util/cards.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_values.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.groupSnapshot}) : super(key: key);

  final Group groupSnapshot;
  final List<CustomNotification> groupMessages = [];
  final GroupController _groupController = new GroupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: getBackButton(context: context),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Image.network(
                groupSnapshot.groupImageURL,
                fit: BoxFit.fitWidth,
              ),
              width: widthOfScreen,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    groupSnapshot.groupName.toString(),
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 27,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfo(groupSnapshot: groupSnapshot,)));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
                      backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                    ),
                    child: Icon(CupertinoIcons.ellipsis),
                  ),
                ],
              ),
            ),
            new StreamBuilder(
              stream: _groupController.getGroupNotifications(groupCode: groupSnapshot.groupCode.toString()),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messageList = snapshot.data!.docs;
                  messageList.forEach((element) {
                    groupMessages.add(CustomNotification.fromJson(element.data() as Map<String, dynamic>));
                  });
                  return GroupNotifs(groupMessages: groupMessages);
                }
                else {
                  return Container(child: CircularProgressIndicator(),);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GroupNotifs extends StatelessWidget {
  const GroupNotifs({Key? key, required this.groupMessages}) : super(key: key);

  final List<CustomNotification> groupMessages;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: getNotificationTile(
                  username: groupMessages[i].userName.toString(),
                  badgeImage: groupMessages[i].badge.picture.toString(),
                  message: groupMessages[i].message.toString(),
                ),
              );
            },
            shrinkWrap: true,
            itemCount: groupMessages.length.toInt(),
            physics: const NeverScrollableScrollPhysics(),
          ),
        ]
    );
  }
}

