import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/main.dart';
import 'package:cyber/view/profile/all_avatars.dart';
import 'package:cyber/view/profile/all_badges.dart';
import 'package:cyber/view/profile/all_courses.dart';
import 'package:cyber/view/profile/edit_profile.dart';
import 'package:cyber/view/util/cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/badge.dart';
import '../../model/level.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class ProfilePage extends GetView<ActiveUserController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();

    //If the coursesSaved of the user change we need to rebuild the page

    return Obx(() => FutureBuilder(
          future: cc.getCourseNamesByIDs(ids: controller.coursesSaved),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ProfilePageContent(coursesSaved: snapshot.data);
            } else if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: getHeadingStyleBlue(),
                ),
              ));
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              );
            }
          },
        ));
  }
}

class ProfilePageContent extends GetView<ActiveUserController> {
  const ProfilePageContent(
      {Key? key, required Map<String, String> this.coursesSaved});

  final Map<String, String> coursesSaved;

  @override
  Widget build(BuildContext context) {
    //Here I define the functions to be executed in the buttons

    return Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          backgroundColor: tertiaryColor,
          elevation: 0,
          actions: [
            IconButton(
              color: secondaryColor,
              iconSize: 24,
              icon: Icon(CupertinoIcons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //When the profile picture of the user changes, we need to change this
                    AvatarPic(
                      size: 0.3 * heightOfScreen,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: heightOfScreen * 0.03,
                            bottom: heightOfScreen * 0.03),
                        child: Obx(() => Text(
                              controller.username.value,
                              style: getHeadingStyleBlue(),
                            ))),

                    //This field is also prone to changes
                    Obx(() => ProgressContainerThreeFields(
                        field1:
                            controller.getNumBadges().toString() + ' Badges',
                        field2:
                            controller.getTotalPoints().toString() + ' Points',
                        field3: controller.getNumAvatars().toString() +
                            ' Avatars')),
                    SizedBox(height: 0.05 * heightOfScreen),
                    Obx(() => LevelProgress(
                          userLevel: controller.level.value,
                        )),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),
                    ProfileSection(
                      typeOfSection: TypeOfSection.Badges,
                      coursesSaved: {},
                      todo: () {
                        Navigator.pushNamed(context, AllBadgesPage.routeName);
                      },
                    ),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),
                    ProfileSection(
                      typeOfSection: TypeOfSection.Avatars,
                      coursesSaved: {},
                      todo: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllAvatarsPage()),
                        );
                        controller.profilePictureActive.refresh();
                      },
                    ),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),
                    ProfileSection(
                      typeOfSection: TypeOfSection.Courses,
                      coursesSaved: coursesSaved,
                      todo: () {
                        Navigator.pushNamed(context, AllCoursesPage.routeName);
                      },
                    ),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),

                    SizedBox(
                      height: 0.07 * heightOfScreen,
                    )
                  ]),
            ),
          ),
        ));
  }
}

/**
 * Class to display the Avatar picture of the user
 */
class AvatarPic extends GetView<ActiveUserController> {
  const AvatarPic({Key? key, required double this.size}) : super(key: key);

  final double size;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Obx(() => Avatar(
          nameOfAvatar: controller.profilePictureActive.value, size: size)),
    );
  }
}

/**
 * Class to create a progress indicator for profile page
 * Shows user level and upper and lower bounds of that level
 */
class LevelProgress extends StatelessWidget {
  const LevelProgress({Key? key, required this.userLevel}) : super(key: key);

  final Level userLevel;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Container(
                height: 0.01 * heightOfScreen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: LinearProgressIndicator(
                    value: (userLevel.xpEarnedInLevel /
                        userLevel.xpAvailableInLevel),
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    backgroundColor: primaryColor,
                  ),
                )),
          ),
          Stack(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          widthOfScreen * 0.01,
                          heightOfScreen * 0.01,
                          widthOfScreen * 0.00,
                          heightOfScreen * 0.01),
                      child: Text("0")),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          widthOfScreen * 0.00,
                          heightOfScreen * 0.01,
                          widthOfScreen * 0.01,
                          heightOfScreen * 0.01),
                      child: Text(userLevel.xpAvailableInLevel.toString())),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: heightOfScreen * 0.01,
                      bottom: heightOfScreen * 0.01),
                  child: Text(
                    "Level ${userLevel.levelNumber}",
                    style: getSubheadingStyleBlue(),
                  ),
                ),
              ),
            ],
          ),
        ]);
  }
}

/**
 * General class to get one of the three different sections in this
 * page.
 */
class ProfileSection extends GetView<ActiveUserController> {
  ProfileSection({
    Key? key,
    required this.typeOfSection,
    required Map<String, String> this.coursesSaved,
    required this.todo,
  }) : super(key: key);

  final TypeOfSection typeOfSection;
  Widget widgetToShow = Container();
  final Map<String, String> coursesSaved;
  final void Function() todo;

  @override
  Widget build(BuildContext context) {
    switch (typeOfSection) {
      case TypeOfSection.Badges:
        {
          widgetToShow = Obx(() =>
              getLastBadgesFromUser(badges: controller.collectedBadges.value));
        }
        break;

      case TypeOfSection.Courses:
        {
          widgetToShow = getLastSavedCoursesFromUser(
              coursesSaved: coursesSaved, context: context);
        }
        break;

      default:
        {
          widgetToShow = Obx(() => getLastAvatarsFromUser(
              avatars: controller.collectedAvatars.value));
        }
        break;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubtitleDivider(
            subtitle: typeOfSection == TypeOfSection.Courses
                ? "My Courses"
                : "My ${typeOfSectionToString[typeOfSection]}"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widgetToShow,
        ),
        SizedBox(
          height: 0.03 * heightOfScreen,
        ),
        SizedBox(
          height: getHeightOfLargeButton(),
          width: getWidthOfLargeButton(),
          child: ElevatedButton(
            style: greyButtonStyle,
            onPressed: todo,
            child: Text(
              'All ${typeOfSectionToString[typeOfSection]}',
              style: getNormalTextStyleBlue(),
            ),
          ),
        )
      ],
    );
  }
}

/**
 * Function to get the last 4 badges from the user.
 * If the user does not have any badge, then a text is provided
 * If the user has less than 4 badges, grey circles are shown
 */
getLastBadgesFromUser({required List<Badge> badges}) {
  if (badges.isEmpty) {
    return Center(
      child: Text(
        'The last 4 badges you earn will appear here',
        style: getNormalTextStyleBlue(),
      ),
    );
  }

  List<Widget> childrenForRow = [];

  if (badges.length == 1) {
    for (int i = 0; i < 1; i++) {
      childrenForRow.add(getContainerForBadge(
          nameOfIcon: badges[i].picture, size: 0.1 * heightOfScreen));
    }
  } else if (badges.length == 2) {
    for (int i = 0; i < 2; i++) {
      childrenForRow.add(getContainerForBadge(
          nameOfIcon: badges[i].picture, size: 0.1 * heightOfScreen));
    }
  } else if (badges.length == 3) {
    for (int i = 0; i < 3; i++) {
      childrenForRow.add(getContainerForBadge(
          nameOfIcon: badges[i].picture, size: 0.1 * heightOfScreen));
    }
  } else {
    for (int i = 0; i < 4; i++) {
      childrenForRow.add(getContainerForBadge(
          nameOfIcon: badges[i].picture, size: 0.1 * heightOfScreen));
    }
  }

  //In case that there are not 3 badges we add grey circles

  if (badges.length < 4) {
    for (int i = 0; i < (4 - badges.length); i++) {
      childrenForRow
          .add(getCircle(color: quinaryColor, size: 0.09 * heightOfScreen));
    }
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: childrenForRow,
  );
}

/**
 * Function to get the last 4 avatars earned by the user
 * In case he has not 4 avatars, grey circles are shown
 */
getLastAvatarsFromUser({required List<String> avatars}) {
  List<Widget> childrenForRow = [];

  //I flip the list so i can access the last avatars

  avatars = List.from(avatars.reversed);

  //we know that in the case of avatars the user is always going to have at least one
  for (int i = 0; i < avatars.length && i < 4; i++) {
    childrenForRow.add(
        AvatarContainer(avatarName: avatars[i], size: 0.1 * heightOfScreen));
  }

  //In case that there are not 3 badges we add grey circles

  if (avatars.length < 4) {
    for (int i = 0; i < (4 - avatars.length); i++) {
      childrenForRow
          .add(getCircle(color: quinaryColor, size: 0.09 * heightOfScreen));
    }
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: childrenForRow,
  );
}

/**
 * Function to get the three last courses saved by the course
 * You need to provide as a param a map with entries of the style
 * <courseID, title> for the coursesSaved to be able to build the cards
 */
getLastSavedCoursesFromUser(
    {required Map<String, String> coursesSaved,
    required BuildContext context}) {
  if (coursesSaved.isEmpty) {
    return Center(
      child: Text(
        'Your completed and saved courses will appear here.',
        style: getNormalTextStyleBlue(),
        textAlign: TextAlign.center,
      ),
    );
  }

  final ActiveUserController controller = Get.find<ActiveUserController>();

  List<Widget> childrenForRow = [];

  coursesSaved.forEach((key, value) {
    childrenForRow.add(getCardForCourse(
        isSaved: true,
        isCompleted: controller.isCompleted(courseID: key),
        courseID: key,
        context: context,
        title: value,
        widthOfCard: 0.4 * widthOfScreen,
        heightOfCard: 0.12 * heightOfScreen,
        isTemplate: false));
  });

  //In case that there are not 3 badges we add grey circles

  if (coursesSaved.length < 2) {
    for (int i = 0; i < (2 - coursesSaved.length); i++) {
      childrenForRow.add(Container(
        width: 0.4 * widthOfScreen,
        height: 0.12 * heightOfScreen,
        decoration: BoxDecoration(
            color: quinaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ));
    }
  }

  return Container(
    height: 0.12 * heightOfScreen,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: childrenForRow,
    ),
  );
}

/**
 * Alert Dialog used to confirm the user deleting or signing out his account.
 * It uses a boolean to differentiate between the two mentioned cases.
 * A function is provided to be executed when the user clicks confirm
 */
class AlertDialogCustom extends StatelessWidget {
  const AlertDialogCustom(
      {Key? key,
      required Future Function() this.todo,
      required bool this.isDelete})
      : super(key: key);

  final Future Function() todo;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'Are you sure?',
        style: getSubheadingStyleBlue(),
      ),
      content: Text(
        isDelete
            ? "This action cannot be undone."
            : "${activeUser!.username} will sign out.",
        style: getNormalTextStyleBlue(),
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
            String message = '';
            await todo().then((value) {
              message = value;
            }).catchError((onError) {
              message = onError;
            });

            var snackBar = SnackBar(
              backgroundColor: secondaryColor,
              content: Text(
                message,
                style: getNormalTextStyleWhite(),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushNamed(context, HomePage.routeName);
          },
          child: Text(
            isDelete ? "Delete" : 'Sign Out',
            style: getNormalTextStyleYellow(),
          ),
        ),
      ],
    );
  }
}

class AvatarContainer extends GetView<ActiveUserController> {
  const AvatarContainer(
      {Key? key, required this.avatarName, required this.size})
      : super(key: key);

  final String avatarName;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        child: Avatar(nameOfAvatar: avatarName, size: size),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: controller.profilePictureActive.value == avatarName
              ? secondaryColor
              : primaryColor,
        )));
  }
}

enum TypeOfSection {
  Badges,
  Avatars,
  Courses,
}

Map<TypeOfSection, String> typeOfSectionToString = {
  TypeOfSection.Courses: 'Courses',
  TypeOfSection.Avatars: 'Avatars',
  TypeOfSection.Badges: 'Badges',
};
