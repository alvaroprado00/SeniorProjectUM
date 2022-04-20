import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/model/group.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/group_controller.dart';
import '../util/k_values.dart';

class GroupCreated extends GetView<ActiveUserController> {
  GroupCreated({Key? key, required this.groupCode}) : super(key: key);

  final GroupController _groupController = new GroupController();
  final String groupCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: tertiaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Success',
          style: getSubheadingStyleBlue(),
        ),
      ),
      body: StreamBuilder(
        stream: _groupController.getGroupByCode(groupCode),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            Group createdGroup =
                Group.fromJson(snapshot.data?.data() as Map<String, dynamic>);
            return GroupSuccess(
              createdGroup: createdGroup,
              controller: controller,
            );
          } else {
            return Center(
              child: Container(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class GroupSuccess extends StatelessWidget {
  const GroupSuccess(
      {Key? key, required this.createdGroup, required this.controller})
      : super(key: key);
  final Group createdGroup;
  final ActiveUserController controller;

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    Widget getGroupCode({required String groupCode}) {
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
            backgroundColor: MaterialStateProperty.all(quinaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 0),
            height: heightOfScreen * 0.28,
            width: getWidthOfLargeButton(),
            child: Image.network(
              createdGroup.groupImageURL,
              fit: BoxFit.fitHeight,
            ),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              createdGroup.groupName,
              style: getHeadingStyleBlue(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  CupertinoIcons.calendar,
                  size: widthOfScreen * 0.07,
                  color: secondaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "FOUNDED",
                  textAlign: TextAlign.center,
                  style: getNormalTextStyleYellowBold(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "${today.day.toString()} ${months[(today.month) - 1]} ${today.year.toString()}",
                  textAlign: TextAlign.center,
                  style: getSubheadingStyleBlue(),
                ),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen,
                right: 0.03 * widthOfScreen,
                top: 16),
            child: SubtitleDivider(subtitle: 'Group Code'),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
            child: Text(
              "Users can join the group with the group code. Tap on the group code to copy and share.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          getGroupCode(groupCode: createdGroup.groupCode),
          SizedBox(
            height: heightOfScreen * 0.03,
          ),
          SizedBox(
            height: getHeightOfLargeButton(),
            width: getWidthOfLargeButton(),
            child: ElevatedButton(
              child: Text(
                "Done",
                style: getNormalTextStyleWhite(),
              ),
              style: blueButtonStyle,
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),
          ),
          SizedBox(
            height: heightOfScreen * 0.07,
          ),
        ],
      ),
    );
  }
}
