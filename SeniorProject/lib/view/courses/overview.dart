import 'package:cyber/config/fixed_values.dart';
import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/group_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/badge.dart';
import 'package:cyber/model/custom_notification.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:cyber/view/courses/overview_dialog.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../util/functions.dart';
import 'category_progress.dart';

class Overview extends GetView<ActiveUserController> {
  const Overview({Key? key}) : super(key: key);

  static final String routeName = '/overview';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SaveCompletedCourseArgs;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Overview',
            style: getSubheadingStyleBlue(),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: tertiaryColor,
        ),
        backgroundColor: tertiaryColor,
        body: ContentForOverview(
            earnedBadge: args.earnedBadge,
            levelUp: args.levelUp,
            balanceXP: args.balanceXP));
  }
}

class ContentForOverview extends GetView<ActiveUserController> {
  const ContentForOverview(
      {required bool this.earnedBadge,
      required bool this.levelUp,
      required int this.balanceXP});

  final bool earnedBadge;
  final bool levelUp;
  final int balanceXP;

  sendUserMessage(BuildContext context) {
    CustomNotification notif = new CustomNotification(
      userName: controller.username.toString(),
      badge: Badge(
          courseID: activeCourse!.id.toString(),
          picture: activeCourse!.badgeIcon.toString(),
          timeEarned: DateTime.now()),
      dateSent: DateTime.now(),
      message: getRandomUpdateMessage(activeCourse!.title).toString(),
    );

    GroupController.addNotification(
        notif: notif, groupCodes: controller.userGroups.toList());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'You earned a new badge.',
          style: getNormalTextStyleBlue(),
        ),
        SizedBox(
          height: 0.025 * heightOfScreen,
        ),
        getSeeBadgeButton(context: context),
        SizedBox(
          height: 0.025 * heightOfScreen,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      //After the widget builds we check if the user has leveled up to show
      //the alert dialog corresponding to that

      if (levelUp) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return OverviewDialog(
                isBadge: false,
              );
            });
      }
    });

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 0.05 * widthOfScreen, right: 0.05 * widthOfScreen),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              Obx(() => getCircularProgressCustom(
                  xp: controller.level.value.xpEarnedInLevel.toString(),
                  level: controller.level.value.levelNumber.toString())),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              Obx(() => Text(
                    'Level ${controller.level.value.levelNumber.toString()}',
                    style: getHeadingStyleBlue(),
                  )),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${getQuestionsRightFromProgress(progress: userProgress).toString()} of ${activeCourse!.numberOfQuestions.toString()}',
                    style: getHeadingStyleBlue(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.arrowtriangle_up_fill,
                        color: Colors.green,
                      ),
                      Text(
                        ' ${balanceXP.toString()} XP',
                        style: getHeadingStyleBlue(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              getCirclesProgressBarForCourseProgression(
                  answers: userProgress,
                  numberOfCircles: activeCourse!.numberOfQuestions),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              earnedBadge
                  ? sendUserMessage(context)
                  : SizedBox(
                      height: 0.1 * heightOfScreen,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getRestartButton(context: context),
                  getNextButton(
                      todo: () {
                        Navigator.pushNamed(
                            context, CategoryProgress.routeName);
                      },
                      large: false),
                ],
              )
            ]),
      ),
    );
  }
}

//The following three methods are used to get widgets for the content of the page
//and make it easier to read

getRestartButton({required BuildContext context}) {
  return SizedBox(
      height: getHeightOfSmallButton(),
      width: getWidthOfSmallButton(),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, CourseDescription.routeName,
              arguments: activeCourse!.id);
        },
        child: Text('Restart', style: getNormalTextStyleBlue()),
        style: yellowButtonStyle,
      ));
}

getSeeBadgeButton({required BuildContext context}) {
  return SizedBox(
      height: getHeightOfLargeButton(),
      width: getWidthOfLargeButton(),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return OverviewDialog(
                  isBadge: true,
                );
              });
        },
        child: Text('See Badge', style: getNormalTextStyleBlue()),
        style: greyButtonStyle,
      ));
}

getCircularProgressCustom({required String xp, required String level}) {
  return SizedBox(
    height: 0.27 * heightOfScreen,
    child: Stack(
      children: <Widget>[
        Center(
          child: Container(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              strokeWidth: 20,
              value: double.parse(xp) /
                  (double.parse(level) * levelScale + baseLevel),
              color: secondaryColor,
              backgroundColor: quaternaryColor,
            ),
          ),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              xp,
              style: TextStyle(
                  fontFamily: 'roboto',
                  color: primaryColor,
                  fontSize: 42,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'XP',
              style: getNormalTextStyleBlue(),
            )
          ],
        )),
      ],
    ),
  );
}

int getQuestionsRightFromProgress({required List<bool> progress}) {
  int numQuestionsRight = 0;
  for (bool b in progress) {
    if (b) {
      numQuestionsRight++;
    }
  }
  return numQuestionsRight;
}
