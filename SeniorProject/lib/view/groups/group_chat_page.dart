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
  List<CustomNotification> groupMessages = [];
  GroupController _groupController = new GroupController();

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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfoPage(groupSnapshot: groupSnapshot,)));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
                      backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                    ),
                    child: Icon(CupertinoIcons.group_solid),
                  ),
                ],
              ),
            ),
            StreamBuilder(
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
            reverse: true,
          ),
        ]
    );
  }
}


// class ChatPage extends StatefulWidget {
//   ChatPage({Key? key, required this.groupSnapshot}) : super(key: key);
//
//   final Group groupSnapshot;
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   List<CustomNotification> groupMessages = [];
//   GroupController _groupController = new GroupController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: getBackButton(context: context),
//         elevation: 0.0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               child: Image.network(
//                 widget.groupSnapshot.groupImageURL,
//                 fit: BoxFit.fitWidth,
//               ),
//               width: widthOfScreen,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 23.0, right: 10.0, top: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text(
//                     widget.groupSnapshot.groupName.toString(),
//                     style: const TextStyle(
//                       color: primaryColor,
//                       fontSize: 27,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfoPage(groupSnapshot: widget.groupSnapshot,)));
//                     },
//                     style: ButtonStyle(
//                       shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
//                       backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
//                       minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
//                     ),
//                     child: Icon(CupertinoIcons.group_solid),
//                   ),
//                 ],
//               ),
//             ),
//             StreamBuilder(
//               stream: _groupController.getGroupNotifications(groupCode: widget.groupSnapshot.groupCode.toString()),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 print(widget.groupSnapshot.groupCode.toString());
//                 if (!snapshot.hasData) {
//                   return Text("Loading...");
//                 }
//                 if (snapshot.hasData) {
//                   List<DocumentSnapshot> messageList = snapshot.data!.docs;
//                   messageList.forEach((element) {
//                     CustomNotification.fromJson(element.data());
//                   });
//                   print(messageList.toString());
//                   return ListView.builder(
//                     reverse: true,
//                     shrinkWrap: true,
//                     itemCount: messageList.length,
//                     itemBuilder: (context, index) {
//                       return getNotificationTile(
//                         username: messageList[index].userName.toString(),
//                         badgeImage: messageList[index].badge.picture.toString(),
//                         message: messageList[index].message.toString(),
//                       );
//                     },
//                   );
//                 }
//                 else {
//                   return Container(child: CircularProgressIndicator(),);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key, required this.snapshot}) : super(key: key);
//
//   final Group snapshot;
//   static final String routeName = "/ChatPage";
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//
//   Column getDayTitle(String day) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 day,
//                 style: const TextStyle(
//                   color: primaryColor,
//                   fontSize: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.only(left: 16.0, right: 16.0),
//           child: Divider(
//             color: primaryColor,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotifications({required BuildContext context,}) {
//
//     return Column(
//         children: [
//           ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemBuilder: (BuildContext context, int i) {
//               return getCardForNotification(
//                   username: widget.snapshot.groupNotifications[i].userName.toString(),
//                   widthOfCard: getWidthOfLargeButton(),
//                   nameOfCourse: widget.snapshot.groupNotifications[i].message.toString(),
//                   heightOfCard: heightOfScreen * 0.12,
//               );
//             },
//             shrinkWrap: true,
//             itemCount: widget.snapshot.groupNotifications.length,
//             physics: const NeverScrollableScrollPhysics(),
//             reverse: true,
//           ),
//         ]
//     );
//   }
//
//   //TODO Separate listview and buildtile methods, create message GetX to use GetBuilder, and Change Notifications card
//
//   @override
//   Widget build(BuildContext context) {
//
//     List<String> usernames = ['Alvarito_007', 'Pablo22', 'elVacan', 'beltrus', 'kerryCaverga', 'Siuu'];
//
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: getBackButton(context: context),
//         elevation: 0.0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               child: Image.network(
//                 widget.snapshot.groupImageURL,
//                 fit: BoxFit.fitWidth,
//               ),
//               width: widthOfScreen,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 23.0, right: 10.0, top: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text(
//                     widget.snapshot.groupName.toString(),
//                     style: const TextStyle(
//                       color: primaryColor,
//                       fontSize: 27,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfoPage(groupName: "Group Name", usernames: usernames)));
//                     },
//                     style: ButtonStyle(
//                       shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
//                       backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
//                       minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
//                     ),
//                     child: Icon(CupertinoIcons.group_solid),
//                   ),
//                 ],
//               ),
//             ),
//             _buildNotifications(context: context),
//           ],
//         ),
//       ),
//     );
//   }
// }

