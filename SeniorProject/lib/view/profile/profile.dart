import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/main.dart';
import 'package:cyber/view/profile/all_badges.dart';

import 'package:cyber/view/profile/edit_profile.dart';
import 'package:cyber/view/util/cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/badge.dart';
import '../../model/level.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();

    return FutureBuilder(
      future: cc.getCourseNamesByIDs(ids: activeUser!.coursesSaved),
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
    );
  }
}

class ProfilePageContent extends StatelessWidget {
  const ProfilePageContent({required Map<String, String> this.coursesSaved});

  final Map<String, String> coursesSaved;

  @override
  Widget build(BuildContext context) {

    //Here I define all the variables that I am going to be using in the user
    final username = activeUser!.username;
    final numBadges = activeUser!.collectedBadges.length;
    final xp = activeUser!.level.totalXP;
    final numAvatars = activeUser!.collectedAvatars.length;
    final level = activeUser!.level;

    //Here I define the functions to be executed in the buttons

   void Function() signOut=(){
     showDialog(context: context, builder: (BuildContext context){
       return AlertDialogCustom(todo:UserController.signOutUser, isDelete: false,);
     });
    };

   void Function() deleteAccount=(){
     showDialog(context: context, builder: (BuildContext context){
       return AlertDialogCustom(todo:UserController.deleteActiveUser, isDelete: true,);
     });
   };

    return Scaffold(
      backgroundColor: tertiaryColor,
        appBar: AppBar(
          backgroundColor: tertiaryColor,
          elevation: 0,
          actions: [
            IconButton(
              color: secondaryColor,
              iconSize: 0.06 * heightOfScreen,
              icon: Icon(CupertinoIcons.pencil_circle),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(dummyUser: getFakeUser())));
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
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Avatar(
                          nameOfAvatar: username, size: 0.6 * widthOfScreen),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: heightOfScreen * 0.03,
                          bottom: heightOfScreen * 0.03),
                      child: Text(
                        username,
                        style: getHeadingStyleBlue(),
                      ),
                    ),
                    ProgressContainerThreeFields(
                        field1: numBadges.toString() + ' Badges',
                        field2: xp.toString() + ' Points',
                        field3: numAvatars.toString() + ' Avatars'),
                    SizedBox(height: 0.05 * heightOfScreen),
                    LevelProgress(
                      userLevel: level,
                    ),
                    SizedBox(height: 0.05*heightOfScreen,),
                    ProfileSection(
                      typeOfSection: TypeOfSection.Badges,
                      coursesSaved: {},
                      todo:() {Navigator.pushNamed(context, AllBadgesPage.routeName);},
                    ),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),
                    ProfileSection(
                      typeOfSection: TypeOfSection.Avatars,
                      coursesSaved: {},
                      todo:() {Navigator.pushNamed(context, AllBadgesPage.routeName);},

                    ),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),
                    ProfileSection(
                      typeOfSection: TypeOfSection.Courses,
                      coursesSaved: coursesSaved,
                      todo:() {Navigator.pushNamed(context, AllBadgesPage.routeName);},

                    ),
                    SizedBox(
                      height: 0.05 * heightOfScreen,
                    ),

                    SubtitleDivider(subtitle: " My Account"),
                    SizedBox(
                        height: getHeightOfLargeButton(),
                        width: getWidthOfLargeButton(),
                        child: ElevatedButton(
                          onPressed: signOut,

                          child:
                              Text('Sign Out', style: getNormalTextStyleBlue()),
                          style: yellowButtonStyle,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: getHeightOfLargeButton(),
                        width: getWidthOfLargeButton(),
                        child: ElevatedButton(
                          onPressed: deleteAccount,
                          child: Text('Delete Account',
                              style: getNormalTextStyleWhite()),
                          style: blueButtonStyle,
                        )),
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
          SizedBox(
              height: 0.01 * heightOfScreen,
              child: LinearProgressIndicator(
                value:
                    (userLevel.xpEarnedInLevel / userLevel.xpAvailableInLevel),
                valueColor:  AlwaysStoppedAnimation<Color>(secondaryColor),
                backgroundColor: primaryColor,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      widthOfScreen * 0.03,
                      heightOfScreen * 0.01,
                      widthOfScreen * 0.00,
                      heightOfScreen * 0.01),
                  child: Text("0")),
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
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      widthOfScreen * 0.00,
                      heightOfScreen * 0.01,
                      widthOfScreen * 0.04,
                      heightOfScreen * 0.01),
                  child: Text(userLevel.xpAvailableInLevel.toString())),
            ],
          ),
        ]);
  }
}

/**
 * General class to get one of the three different sections in this
 * page.
 */
class ProfileSection extends StatelessWidget {
  ProfileSection({
    Key? key,
    required this.typeOfSection,
    required Map<String, String> this.coursesSaved,
    required this.todo,
  }) : super(key: key);

  final TypeOfSection typeOfSection;
  Widget widgetToShow =
      getLastBadgesFromUser(badges: activeUser!.collectedBadges);
  final Map<String, String> coursesSaved;
  final void Function() todo;

  @override
  Widget build(BuildContext context) {
    switch (typeOfSection) {
      case TypeOfSection.Badges:
        {
          widgetToShow =
              getLastBadgesFromUser(badges: activeUser!.collectedBadges);
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
          widgetToShow =
              getLastAvatarsFromUser(avatars: activeUser!.collectedAvatars);
        }
        break;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubtitleDivider(subtitle: "My ${typeOfSectionToString[typeOfSection]}"),
        widgetToShow,
        SizedBox(
          height: 0.05 * heightOfScreen,
        ),
        SizedBox(
          height: getHeightOfLargeButton(),
          width: getWidthOfLargeButton(),
          child: ElevatedButton(
            style: greyButtonStyle,
            onPressed: todo,
            child: Text(
              'See all ${typeOfSectionToString[typeOfSection]}',
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

  for (int i = 0; i < badges.length; i++) {
    childrenForRow.add(getContainerForBadge(
        nameOfIcon: badges[i].picture, size: 0.1 * heightOfScreen));
  }

  //In case that there are not 3 badges we add grey circles

  if (badges.length < 4) {
    for (int i = 0; i < (4 - badges.length); i++) {
      childrenForRow
          .add(getCircle(color: quinaryColor, size: 0.1 * heightOfScreen));
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

  //we know that in the case of avatars the user is always going to have at least one
  for (int i = 0; i < avatars.length; i++) {
    childrenForRow
        .add(Avatar(nameOfAvatar: avatars[i], size: 0.1 * heightOfScreen));
  }

  //In case that there are not 3 badges we add grey circles

  if (avatars.length < 4) {
    for (int i = 0; i < (4 - avatars.length); i++) {
      childrenForRow
          .add(getCircle(color: quinaryColor, size: 0.1 * heightOfScreen));
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
        'Your last 2 saved courses will appear here',
        style: getNormalTextStyleBlue(),
      ),
    );
  }

  List<Widget> childrenForRow = [];

  coursesSaved.forEach((key, value) {
    childrenForRow.add(getCardForCourse(
        isSaved: true,
        isCompleted: activeUser!.isCourseCompleted(courseID: key),
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
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ));
    }
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: childrenForRow,
  );
}

class AlertDialogCustom extends StatelessWidget {
  const AlertDialogCustom({Key? key, required Future Function() this.todo, required bool this.isDelete}) : super(key: key);

  final Future Function () todo;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Are you sure?', style: getNormalTextStyleBlue(),),
      content: Text(
         isDelete?" You will sign out.": "You will delete your account", style: getNormalTextStyleBlue(),),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.pop(context, 'Cancel'),
          child: Text('Cancel',style: getNormalTextStyleBlue(),),
        ),
        TextButton(
          onPressed: () async {
            String message='';
            await todo().then((value){

              message=value;
            }).catchError((onError){message=onError;});

            var snackBar = SnackBar(
              backgroundColor: secondaryColor,
              content: Text(message, style: getNormalTextStyleWhite(),),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushNamed(context, HomePage.routeName);

          },
          child:  Text('Confirm', style: getNormalTextStyleYellow(),),
        ),
      ],
    );
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
