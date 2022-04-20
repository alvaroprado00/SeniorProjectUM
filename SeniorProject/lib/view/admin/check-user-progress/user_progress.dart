import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/user_custom.dart';
import '../../util/components.dart';
import '../../util/functions.dart';
import '../../util/k_colors.dart';
import '../../util/k_styles.dart';

class UserProgressPage extends StatelessWidget {
  const UserProgressPage({Key? key}) : super(key: key);

  static final String routeName = 'userProgress';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'User Progress',
          style: getSubheadingStyleWhite(),
        ),
        centerTitle: true,
        elevation: 0,
        leading: getBackButton(context: context),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: UserController.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text(
                  'No users found.',
                  style: getSubheadingStyleWhite(),
                ),
              );
            }

            return UserProgressContent(
              users: snapshot.data,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error when getting users',
                style: getSubheadingStyleWhite(),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          }
        },
      ),
    );
  }
}

class UserProgressContent extends StatefulWidget {
  const UserProgressContent({Key? key, required this.users}) : super(key: key);

  //Here I have the list of users in the Database which i will use
  //to get the user that the admin wants to know about
  final List<UserCustom> users;

  @override
  _UserProgressContentState createState() => _UserProgressContentState();
}

class _UserProgressContentState extends State<UserProgressContent> {
  late final _controllerUsername;
  late final _formKey;
  late bool _userSearched;
  late bool _userValid;
  late String _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
    _controllerUsername = TextEditingController();
    _userSearched = false;
    _userValid = false;
    _username = '';
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function() formFunction = () {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _userSearched = true;
          _username = _controllerUsername.text.trim();
          if (checkIfUsernameExists(username: _username)) {
            _userValid = true;
          } else {
            _userValid = false;
          }
        });
      }
    };

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 0.03 * heightOfScreen,
          ),
          Text(
            'Enter a username to view progress.',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 0.03 * heightOfScreen,
          ),
          Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 0.75 * widthOfScreen,
                    child: TextFormField(
                      validator: validatorForEmptyTextField,
                      controller: _controllerUsername,
                      decoration: getInputDecoration(
                        hintText: 'Username',
                        icon: Icon(
                          Icons.person,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: quaternaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                        onPressed: formFunction,
                        icon: Icon(
                          Icons.search,
                          color: secondaryColor,
                        )),
                  ),
                ],
              )),
          _userSearched
              ? ContentForUser(
                  users: widget.users, username: _username, isValid: _userValid)
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }

  bool checkIfUsernameExists({required String username}) {
    for (UserCustom u in widget.users) {
      if (u.username.toLowerCase() == username.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}

class ContentForUser extends StatelessWidget {
  const ContentForUser(
      {Key? key,
      required List<UserCustom> this.users,
      required String this.username,
      required bool this.isValid})
      : super(key: key);

  final List<UserCustom> users;
  final String username;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return isValid
        ? Stack(children: [
            UserOverview(
                user: users
                    .where((element) =>
                        element.username.toLowerCase() ==
                        username.toLowerCase())
                    .first),
          ])
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.1 * heightOfScreen,
              ),
              Icon(
                CupertinoIcons.person_crop_circle_fill_badge_xmark,
                color: secondaryColor,
                size: 48,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'User not found.',
                  style: getSubheadingStyleWhite(),
                ),
              ),
            ],
          );
  }
}

class UserOverview extends StatelessWidget {
  const UserOverview({Key? key, required UserCustom this.user})
      : super(key: key);

  final UserCustom user;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, right: 24, left: 24, bottom: 30),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
      decoration: BoxDecoration(
          border: Border.all(color: secondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                user.isAdmin
                    ? Icons.admin_panel_settings
                    : CupertinoIcons.person_crop_circle,
                size: 48,
                color: secondaryColor,
              ),
              Container(
                alignment: Alignment.center,
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(24))),
                child: Text(
                  '${user.level.levelNumber}',
                  style: getSubheadingStyleWhite(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.03 * heightOfScreen,
          ),
          Container(
              child: Avatar(
                  nameOfAvatar: user.profilePictureActive,
                  size: 0.2 * heightOfScreen),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: secondaryColor)),
          SizedBox(
            height: 0.03 * heightOfScreen,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                user.username,
                style: getHeadingStyleWhite(),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  user.email,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: secondaryColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.05 * heightOfScreen,
          ),
          ProgressIndicator(
              label: 'Courses Saved', num: user.coursesSaved.length),
          ProgressIndicator(
              label: 'Courses Completed', num: user.completedCourses.length),
          ProgressIndicator(
              label: 'Badges Earned', num: user.collectedBadges.length),
          ProgressIndicator(
              label: 'Avatars Collected', num: user.collectedAvatars.length),
        ],
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({Key? key, required this.label, required this.num})
      : super(key: key);

  final String label;
  final int num;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: getNormalTextStyleWhite(),
            ),
            Text(
              num.toString(),
              style: getNormalTextStyleYellow(),
            )
          ],
        ),
        Divider(
          color: tertiaryColor,
          thickness: 1,
        ),
      ],
    );
  }
}
