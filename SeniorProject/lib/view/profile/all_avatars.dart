import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class AllAvatarsPage extends GetView<ActiveUserController> {
  const AllAvatarsPage({Key? key}) : super(key: key);

  static final routeName = '/allAvatars';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Avatars",
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.05 * heightOfScreen,
            ),
            SubtitleDivider(subtitle: 'Collected'),
            SizedBox(
              height: 0.03 * heightOfScreen,
            ),
            SizedBox(
              width: widthOfScreen,
              height: 0.5 * heightOfScreen,
              child: SingleChildScrollView(
                child: Obx(() => getAvatars(
                    userAvatars: controller.collectedAvatars.value,
                    size: 0.11 * heightOfScreen)),
              ),
            ),
            SizedBox(
              height: 0.06 * heightOfScreen,
            ),
            Container(
              width: widthOfScreen,
              height: 0.2 * heightOfScreen,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.transparent,
                    Colors.transparent,
                  ])),
              child: Image.asset(
                'assets/images/help.png',
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAvatars({required List<String> userAvatars, required double size}) {
    List<Widget> childrenOfRow = [];

    //The user is always going to have at least one avatar so I dont
    //check for the user not having avatars
    for (String s in userAvatars) {
      //The Avatars are going to be Obx because depend on the value of the vble activeUser
      childrenOfRow.add(AvatarButton(
        avatarName: s,
        size: size,
      ));
    }

    return Wrap(
      runSpacing: 10,
      spacing: 5,
      children: childrenOfRow,
    );
  }
}

/**
 * This class when built displays a button with an avatar. The button
 * will have a yellow background in case the avatar displayed is the that
 * the user is currently having as his profilePictureActive
 */
class AvatarButton extends StatelessWidget {
  AvatarButton(
      {Key? key, required String this.avatarName, required double this.size})
      : super(key: key);

  final String avatarName;
  final double size;

  ActiveUserController activeUserController = Get.find<ActiveUserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: activeUserController.profilePictureActive == avatarName
                  ? secondaryColor
                  : primaryColor),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) {
                  return AvatarDialog(
                    avatarName: avatarName,
                  );
                });
          },
          child: Avatar(nameOfAvatar: avatarName, size: size),
        ));
  }
}

/**
 * A custom dialog that is displayed when the user clicks on the
 * avatar icon. It lets the user change its active profile pic
 */
class AvatarDialog extends GetView<ActiveUserController> {
  const AvatarDialog({Key? key, required String this.avatarName})
      : super(key: key);

  final String avatarName;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Avatar',
        style: getSubheadingStyleBlue(),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(nameOfAvatar: avatarName, size: 0.3 * heightOfScreen),
          SizedBox(
            height: 0.05 * heightOfScreen,
          ),
          Text(
            'Avatar ID: ${avatarName}',
            style: getNormalTextStyleBlue(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            'Cancel',
            style: getNormalTextStyleBlue(),
          ),
        ),
        TextButton(
          onPressed: () async {
            //We change the active User
            activeUser!.profilePictureActive = avatarName;

            String message = '';
            await controller
                .updateProfilePictureActive(newPicture: avatarName)
                .then((value) {
              if (value) {
                message = 'Changes Applied';
              } else {
                message = 'Changes not applied';
              }
            }).catchError((onError) {
              message = 'Something went wrong';
            });

            var snackBar = SnackBar(
              backgroundColor: secondaryColor,
              content: Text(
                message,
                style: getNormalTextStyleWhite(),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          },
          child: Text(
            'Change',
            style: getNormalTextStyleYellow(),
          ),
        ),
      ],
    );
  }
}
