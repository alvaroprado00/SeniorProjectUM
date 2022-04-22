import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/k_styles.dart';

/**
 * This class is used to show an alert dialog in the overview page
 * It can be used to show the user he has leveled up or it can be used
 * to show the badge that he has earned
 *
 */
class OverviewDialog extends StatelessWidget {
  const OverviewDialog({required bool this.isBadge});

  final bool isBadge;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        isBadge ? 'COURSE' : 'AVATAR UNLOCKED',
        style: getNormalTextStyleYellowBold(),
        textAlign: TextAlign.center,
      ),
      content: isBadge ? BadgeContent() : LevelUpContent(),
      insetPadding: EdgeInsets.all(10),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          child: Text("CLOSE", style: getNormalTextStyleBlue()),
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

class LevelUpContent extends GetView<ActiveUserController> {
  const LevelUpContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => Avatar(
            nameOfAvatar: controller.collectedAvatars.value.last,
            size: 0.2 * heightOfScreen)),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            'UNIQUE ID',
            style: getNormalTextStyleYellowBold(),
          ),
        ),
        Obx(() => Text(
              '${controller.collectedAvatars.value.last}',
              style: getNormalTextStyleBlue(),
            )),
      ],
    );
  }
}

class BadgeContent extends GetView<ActiveUserController> {
  const BadgeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => getContainerForBadge(
            nameOfIcon: controller.collectedBadges.value.last.picture,
            size: 0.2 * heightOfScreen)),
        Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 8, right: 16, left: 16),
          child: Text(
            '${activeCourse!.title}',
            style: getSubheadingStyleBlue(),
          ),
        ),
      ],
    );
  }
}
