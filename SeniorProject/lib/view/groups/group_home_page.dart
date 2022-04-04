import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/group.dart';
import '../util/components.dart';
import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';
import 'group_chat_page.dart';
import 'group_create_page.dart';

// class GroupHome extends StatefulWidget {
//   const GroupHome({Key? key}) : super(key: key);
//
//   static final String routeName = '/GroupHome';
//
//   @override
//   _GroupHomeState createState() => _GroupHomeState();
// }
//
// class _GroupHomeState extends State<GroupHome> {
//
//   late TextEditingController _controllerJoin;
//   GroupController _groupController = new GroupController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controllerJoin = TextEditingController();
//   }
//
//   //Here we free the memory
//   @override
//   void dispose() {
//     _controllerJoin.dispose();
//     super.dispose();
//   }
//
//   /**
//    * GROUP PAGE
//    * Function returns a list tile for a group.
//    * It requires an image path and a group name as well as a bool if there are unread notifications.
//    */
//   Widget _buildGroupTile({required String groupName, required String imagePath, bool notification = false}) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: AssetImage('assets/images/group_icon_default.png'),
//         backgroundColor: Colors.transparent,
//       ),
//       title: Text(
//         groupName,
//         style: getNormalTextStyleBlue(),
//       ),
//       trailing: Row(
//         children: [
//           getNotification(notification),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.arrow_forward_ios,
//               color: primaryColor,
//               size: 30.0,
//             ),
//           ),
//         ],
//         mainAxisSize: MainAxisSize.min,
//       ),
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupName: groupName,)));
//       },
//     );
//   }
//
//   /**
//    * GROUP PAGE
//    * Function returns a list of group tiles.
//    * It requires a list of image paths and a list of group names.
//    * must pass context
//    */
//   Widget _buildGroups({required BuildContext context}) {
//     return StreamBuilde();
//     if (groupNames != null && imagePaths != null) {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemBuilder: (BuildContext context, int i) {
//           return _buildGroupTile(groupName: groupNames[i], imagePath: imagePaths[i], notification: true);
//         },
//         shrinkWrap: true,
//         itemCount: groupNames.length,
//         physics: const NeverScrollableScrollPhysics(),
//       );
//     }
//     else {
//       return Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'You are currently not in a group.',
//               style: getNormalTextStyleBlue(),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   Widget _buildPopupDialog(BuildContext context, String groupCode) {
//     return new AlertDialog(
//       title: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Icon(Icons.close, color: primaryColor,),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
//                   elevation: MaterialStateProperty.all<double>(0.0),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               'You Joined',
//               style: getHeadingStyleBlue(),
//             ),
//           ),
//         ],
//       ),
//       content: StreamBuilder(
//         stream: _groupController.getGroupByCode(groupCode),
//         builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//           if(snapshot.hasData) {
//             Group createdGroup = Group.fromJson(snapshot.data?.data() as Map<String, dynamic>);
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(createdGroup.groupImageURL,),
//                   radius: widthOfScreen * 0.1,
//                   backgroundColor: primaryColor,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Text(
//                     createdGroup.groupName,
//                     style: getSubheadingStyleBlue(),
//                   ),
//                 ),
//               ],
//             );
//           }
//           else {
//             return Center(
//               child: CircularProgressIndicator(color: primaryColor,),
//             );
//           }
//         }
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     List<String> imagePaths = ['assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png'];
//     List<String> groupNames = ['Canes', 'Los_Yankis', 'ECE Course', 'Team', 'Alvarito', 'Chupacabra'];
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 5.0),
//               child: Image.asset(
//                 'assets/images/group_home_banner.png',
//                 width: widthOfScreen,
//               ),
//             ),
//             getTitleAndDivider('Groups'),
//             _buildGroups(context: context, imagePaths: imagePaths, groupNames: groupNames,),
//             getTitleAndDivider('Join'),
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
//               child: TextFormField(
//                 controller: _controllerJoin,
//                 validator: validatorForEmptyTextField,
//                 decoration: getInputDecoration(
//                   hintText: 'Join with Group Code',
//                   icon: const Icon(
//                     Icons.group,
//                     color: secondaryColor,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
//               child: SizedBox(
//                   height: getHeightOfLargeButton(),
//                   width: getWidthOfLargeButton(),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if(validatorForEmptyTextField != null) {
//                         ActiveUserController.
//                           .whenComplete(() {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) => _buildPopupDialog(context, _controllerJoin.text),
//                             );
//                           })
//                           .catchError((e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Group not found. Please enter the correct group code.',
//                                   style: TextStyle(
//                                     color: primaryColor,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 backgroundColor: secondaryColor,
//                               )
//                             );
//                           });
//                         GroupController.addCurrentUserToGroup(groupCode: _controllerJoin.text);
//                       }
//                     },
//                     child: Text('Join Group', style: getNormalTextStyleWhite()),
//                     style: blueButtonStyle,
//                   )),
//             ),
//             getTitleAndDivider('Create'),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 height: getHeightOfLargeButton(),
//                 width: getWidthOfLargeButton(),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, CreateGroup.routeName);
//                   },
//                   child: Text('Create a Group', style: getNormalTextStyleWhite(),),
//                   style: blueButtonStyle,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         clipBehavior: Clip.hardEdge,
//       ),
//     );
//   }
// }


class GroupsHome extends StatelessWidget {
  GroupsHome({Key? key}) : super(key: key);

  static final String routeName = '/GroupHome';
  final TextEditingController _controllerJoin = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Image.asset(
                'assets/images/group_home_banner.png',
                width: widthOfScreen,
              ),
            ),
            SubtitleDivider(subtitle: 'Groups',),
            GroupChats(),
            SubtitleDivider(subtitle: 'Join',),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: TextFormField(
                controller: _controllerJoin,
                validator: validatorForEmptyTextField,
                decoration: getInputDecoration(
                  hintText: 'Join with Group Code',
                  icon: const Icon(
                    Icons.group,
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
              child: SizedBox(
                  height: getHeightOfLargeButton(),
                  width: getWidthOfLargeButton(),
                  child: ElevatedButton(
                    onPressed: () {
                      if(validatorForEmptyTextField != null) {
                        ActiveUserController().updateUserGroups(groupCode: _controllerJoin.text)
                        .whenComplete(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => JoinPopup(groupCode: _controllerJoin.text),
                          );
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Group not found. Please enter the correct group code.',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: secondaryColor,
                            )
                          );
                        });
                        GroupController.addCurrentUserToGroup(groupCode: _controllerJoin.text);
                      }
                    },
                    child: Text('Join Group', style: getNormalTextStyleWhite()),
                    style: blueButtonStyle,
                  )),
            ),
            SubtitleDivider(subtitle: 'Create',),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CreateGroup.routeName);
                  },
                  child: Text('Create a Group', style: getNormalTextStyleWhite(),),
                  style: blueButtonStyle,
                ),
              ),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }
}

class GroupChats extends GetView<ActiveUserController> {
  const GroupChats({Key? key}) : super(key: key);

  Widget _buildGroupTile({required String groupCode}) {
    GroupController _groupController = new GroupController();
    return StreamBuilder(
      stream: _groupController.getGroupByCode(groupCode),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData) {
          Group createdGroup = Group.fromJson(snapshot.data?.data() as Map<String, dynamic>);
          return Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0,),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(snapshot: createdGroup,)));
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(createdGroup.groupImageURL,),
                radius: widthOfScreen * 0.06,
                backgroundColor: primaryColor,
              ),
              title: Text(
                createdGroup.groupName,
                style: getSubheadingStyleBlue(),
              ),

              trailing: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: primaryColor,
                  size: widthOfScreen * 0.07,
                ),
              ),
            ),
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(color: primaryColor,),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> userGroups = controller.userGroups;
    return Obx(() => controller.userGroups != null && controller.userGroups.value.isNotEmpty ?
    ListView.builder(
      padding: const EdgeInsets.all(2.0),
      itemBuilder: (BuildContext context, int index) {
        return _buildGroupTile(groupCode: controller.userGroups.value.elementAt(index));
      },
      shrinkWrap: true,
      itemCount: controller.userGroups.value.length,
      physics: const NeverScrollableScrollPhysics(),
    ) : Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are currently not in a group.',
            style: getNormalTextStyleBlue(),
          ),
        ],
      ),
    ));
  }
}

class JoinPopup extends StatelessWidget {
  JoinPopup({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;
  final GroupController _groupController = new GroupController();

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, color: primaryColor,),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0.0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'You Joined',
              style: getHeadingStyleBlue(),
            ),
          ),
        ],
      ),
      content: StreamBuilder(
          stream: _groupController.getGroupByCode(groupCode),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasData) {
              Group createdGroup = Group.fromJson(snapshot.data?.data() as Map<String, dynamic>);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(createdGroup.groupImageURL,),
                    radius: widthOfScreen * 0.1,
                    backgroundColor: primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      createdGroup.groupName,
                      style: getSubheadingStyleBlue(),
                    ),
                  ),
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(color: primaryColor,),
              );
            }
          }
      ),
    );
  }
}


