import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/profile/all_avatars.dart';
import 'package:cyber/view/profile/all_badges.dart';
import 'package:cyber/view/profile/all_courses.dart';
import 'package:cyber/view/profile/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.buildContext}) : super(key: key);
  final BuildContext buildContext;

  //static UserCustom dummyUser = UserCustom("dummy@user.com", "el_dummy");
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Create a dummy user to user in screens

  // UserCustom dummyUser = UserCustom(
  //   email: "dummy@user.com",
  //   username: "el_dummy",
  //   level: Level(totalXP: 100, xpInLevel: 50, levelNumber: 1),
  //   isAdmin: true,
  //
  // );
  InfoTriple info1 = InfoTriple(topLine: "120", bottomLine: "Badges");
  InfoTriple info2 = InfoTriple(topLine: "230", bottomLine: "Points");
  InfoTriple info3 = InfoTriple(topLine: "25", bottomLine: "Avatars");
  // This will build the three categories for user profile information

  @override
  Widget build(BuildContext context) {
    //final userCreated = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  color: secondaryColor,
                  iconSize: 0.04 * heightOfScreen,
                  icon: Icon(CupertinoIcons.pencil_circle),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(dummyUser: getFakeUser())));
                    //print("Icon Presssed");
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Avatar(nameOfAvatar: getFakeUser().username, size: 200),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: heightOfScreen * 0.03, bottom: heightOfScreen * 0.03),
                child: Text(
                  getFakeUser().username,
                  style: getHeadingStyleBlue(),
                ),
              ),
              threeSectionMenuProfile(dummyUser: getFakeUser()),
              LevelProgress(dummyUser: getFakeUser()),
              SubtitleDivider(subtitle: "My Badges"),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: CircleBorder()),
                child: Container(
                    width: widthOfScreen * 0.1,
                    height: heightOfScreen * 0.1,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.group_rounded,
                      color: secondaryColor,
                    )),
              ),
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                  height: 0.07 * heightOfScreen,
                  width: 0.95 * widthOfScreen,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllBadgesPage(dummyUser: getFakeUser())));
                    },
                    child:
                        Text('See All Badges', style: getNormalTextStyleBlue()),
                    style: greyButtonStyle,
                  )),
              SizedBox(
                height: 10,
              ),
              SubtitleDivider(subtitle: "My Avatars"),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: CircleBorder()),
                child: Avatar(
                    nameOfAvatar: getFakeUser().username,
                    size: widthOfScreen * 0.2),
              ),
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                  height: 0.07 * heightOfScreen,
                  width: 0.95 * widthOfScreen,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllAvatarsPage(dummyUser: getFakeUser())));
                    },
                    child: Text('See All Avatars',
                        style: getNormalTextStyleBlue()),
                    style: greyButtonStyle,
                  )),
              SizedBox(
                height: 10,
              ),
              SubtitleDivider(subtitle: "My Courses"),
              SizedBox(
                  height: 0.07 * heightOfScreen,
                  width: 0.95 * widthOfScreen,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllCoursePage(dummyUser: getFakeUser())));
                    },
                    child: Text('See All Courses',
                        style: getNormalTextStyleBlue()),
                    style: greyButtonStyle,
                  )),
              SizedBox(
                height: 10,
              ),
              SubtitleDivider(subtitle: " My Account"),
              SizedBox(
                  height: 0.07 * heightOfScreen,
                  width: 0.95 * widthOfScreen,
                  child: ElevatedButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content:
                            Text(getFakeUser().username + " will sign out."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              UserController.signOutUser();
                              Navigator.pop(context, 'Confirm');
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ),
                    child: Text('Sign Out', style: getNormalTextStyleBlue()),
                    style: yellowButtonStyle,
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 0.07 * heightOfScreen,
                  width: 0.95 * widthOfScreen,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Delete Account',
                        style: getNormalTextStyleWhite()),
                    style: blueButtonStyle,
                  )),
              SizedBox(
                height: 0.07 * heightOfScreen,
              )
            ]),
      ),
    ));
  }
}
