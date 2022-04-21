import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/active_group_controller.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/group_controller.dart';
import 'package:flutter/cupertino.dart';
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

class GroupsHome extends StatelessWidget {
  GroupsHome({Key? key}) : super(key: key);

  static final String routeName = '/GroupHome';
  ActiveUserController userController = Get.put(ActiveUserController()); // Rather Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: tertiaryColor,
          title: Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Cyber ',
                style: TextStyle(
                    color: secondaryColor,
                    fontFamily: fontFamily,
                    fontSize: 36,
                    fontWeight: FontWeight.w700)),
            TextSpan(
                text: 'Community',
                style: TextStyle(
                    color: primaryColor,
                    fontFamily: fontFamily,
                    fontSize: 36,
                    fontWeight: FontWeight.w200)),
          ]))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 16,
                  left: 0.06 * widthOfScreen,
                  right: 0.06 * widthOfScreen,
                  bottom: 24),
              child: Text(
                'We find value in community learning. By joining groups you can share your badges with your friends. You can also create new groups and share the code with select people.',
                style: getSmallTextStyleGrey(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: SubtitleDivider(
                subtitle: 'My Groups',
              ),
            ),
            GroupChats(),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: SubtitleDivider(
                subtitle: 'Join Group',
              ),
            ),
            JoinGroup(),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: SubtitleDivider(
                subtitle: 'Create Group',
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: () {
                    // Get.toNamed(CreateGroup.routeName);
                    Navigator.pushNamed(context, CreateGroup.routeName);
                  },
                  child: Text(
                    'Begin',
                    style: getNormalTextStyleWhite(),
                  ),
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

  @override
  Widget build(BuildContext context) {
    return controller.userGroups != null &&
            controller.userGroups.value.isNotEmpty
        ? GetBuilder<ActiveUserController>(
            builder: (controller) => ListView.builder(
              padding: const EdgeInsets.all(2.0),
              itemBuilder: (BuildContext context, int index) {
                return GroupTile(
                    groupCode: controller.userGroups.value.elementAt(index));
              },
              shrinkWrap: true,
              itemCount: controller.userGroups.value.length,
              physics: const NeverScrollableScrollPhysics(),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You are currently not in a group.',
                  style: getNormalTextStyleBlue(),
                ),
              ],
            ),
          );
  }
}

class GroupTile extends StatelessWidget {
  GroupTile({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;
  final GroupController _groupController = new GroupController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _groupController.getGroupByCode(groupCode),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return SizedBox(
              height: 0.01,
            );
          } else {
            Group createdGroup =
                Group.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            return Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                bottom: 4.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.put(
                      ActiveGroupController(
                        inGroupCode: createdGroup.groupCode,
                        inGroupName: createdGroup.groupName,
                        inGroupAdmin: createdGroup.groupAdmin,
                        inDateCreated: createdGroup.dateCreated,
                        inGroupMembers: createdGroup.groupMembers,
                        inGroupImageURL: createdGroup.groupImageURL,
                      ),
                      tag: createdGroup.groupCode);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new ChatPage(
                                groupCode: createdGroup.groupCode,
                              )));
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    createdGroup.groupImageURL,
                  ),
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
                    CupertinoIcons.chevron_right,
                    color: primaryColor,
                    size: widthOfScreen * 0.07,
                  ),
                ),
              ),
            );
          }
        });
  }
}

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerJoin = new TextEditingController();
  ActiveUserController userController = Get.find<ActiveUserController>();

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerJoin = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerJoin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 2.0, bottom: 12.0, left: 16.0, right: 16.0),
          child: TextFormField(
            key: _formKey,
            controller: _controllerJoin,
            validator: groupCodeValidator,
            decoration: getInputDecoration(
              hintText: 'Group Code',
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
                  if (groupCodeValidator(_controllerJoin.text) == null) {
                    userController
                        .updateUserGroups(groupCode: _controllerJoin.text)
                        .whenComplete(() {
                      userController.update();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            JoinPopup(groupCode: _controllerJoin.text),
                      );
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Group code not found. Try again',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: secondaryColor,
                      ));
                    });
                    GroupController.addCurrentUserToGroup(
                        groupCode: _controllerJoin.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Invalid Group Code',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      backgroundColor: secondaryColor,
                    ));
                  }
                },
                child: Text('Join', style: getNormalTextStyleWhite()),
                style: blueButtonStyle,
              )),
        ),
      ],
    );
  }
}

class JoinPopup extends StatelessWidget {
  JoinPopup({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;
  final GroupController _groupController = new GroupController();

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      alignment: Alignment.center,
      title: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'SUCCESS',
          style: getNormalTextStyleYellowBold(),
          textAlign: TextAlign.center,
        ),
      ),
      content: StreamBuilder(
          stream: _groupController.getGroupByCode(groupCode),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              Group createdGroup =
                  Group.fromJson(snapshot.data?.data() as Map<String, dynamic>);
              Get.put(
                  ActiveGroupController(
                    inGroupCode: createdGroup.groupCode,
                    inGroupName: createdGroup.groupName,
                    inGroupAdmin: createdGroup.groupAdmin,
                    inDateCreated: createdGroup.dateCreated,
                    inGroupMembers: createdGroup.groupMembers,
                    inGroupImageURL: createdGroup.groupImageURL,
                  ),
                  tag: createdGroup.groupCode);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      createdGroup.groupImageURL,
                    ),
                    radius: widthOfScreen * 0.25,
                    backgroundColor: primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      createdGroup.groupName,
                      style: getSubheadingStyleBlue(),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
          }),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          child: Text("Done", style: getNormalTextStyleBlue()),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
      ],
    );
  }
}
