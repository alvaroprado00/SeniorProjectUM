import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/view/profile/all_avatars.dart';
import 'package:cyber/view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import '../../main.dart';
import '../util/components.dart';
import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';
import 'change_password.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static final String routeName = '/editProfilePage';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: getSubheadingStyleBlue(),
          ),
          leading: getBackButton(context: context),
          elevation: 0,
          centerTitle: true,
          backgroundColor: tertiaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                AvatarSection(),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                SubtitleDivider(subtitle: 'Username'),
                UsernameForm(),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                PasswordSection(),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                EmailSection(),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                SignOutDeleteContent(),
                SizedBox(
                  height: 0.02 * heightOfScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignOutDeleteContent extends GetView<ActiveUserController> {
  const SignOutDeleteContent({Key? key});
  @override
  Widget build(BuildContext context) {
    void Function() signOut = () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
              todo: controller.signOut,
              isDelete: false,
            );
          });
    };

    void Function() deleteAccount = () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
              todo: controller.delete,
              isDelete: true,
            );
          });
    };
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubtitleDivider(subtitle: "My Account"),
          SizedBox(
              height: getHeightOfLargeButton(),
              width: getWidthOfLargeButton(),
              child: ElevatedButton(
                onPressed: signOut,
                child: Text('Sign Out', style: getNormalTextStyleBlue()),
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
                child: Text('Delete Account', style: getNormalTextStyleWhite()),
                style: blueButtonStyle,
              )),
          SizedBox(
            height: 0.07 * heightOfScreen,
          )
        ]);
  }
}

class AvatarSection extends StatelessWidget {
  const AvatarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarPic(
          size: 0.2 * heightOfScreen,
        ),
        SizedBox(
          height: 0.03 * heightOfScreen,
        ),
        SizedBox(
          height: getHeightOfLargeButton(),
          width: getWidthOfLargeButton(),
          child: ElevatedButton(
            child: Text(
              'Change Avatar',
              style: getNormalTextStyleBlue(),
            ),
            style: greyButtonStyle,
            onPressed: () {
              Navigator.pushNamed(context, AllAvatarsPage.routeName);
            },
          ),
        )
      ],
    );
  }
}

class UsernameForm extends GetView<ActiveUserController> {
  UsernameForm({Key? key}) : super(key: key);

  //Here I initiaize the variables needed for the form

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerUsername = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Function to be executed in the form

    void Function() changeUsername = () {
      if (_formKey.currentState!.validate()) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogUsername(
                newUsername: _controllerUsername.text,
              );
            }).then((value) => {
              //Clean textformfield
              _controllerUsername.clear()
            });
      }
    };

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => TextFormField(
                  validator: validatorForEmptyTextField,
                  controller: _controllerUsername,
                  decoration: getInputDecoration(
                      hintText: controller.username.value,
                      icon: Icon(
                        Icons.person,
                        color: secondaryColor,
                      )),
                )),
            SizedBox(
              height: 0.02 * heightOfScreen,
            ),
            SizedBox(
              height: getHeightOfLargeButton(),
              width: getWidthOfLargeButton(),
              child: ElevatedButton(
                onPressed: changeUsername,
                style: yellowButtonStyle,
                child: Text('Save', style: getNormalTextStyleBlue()),
              ),
            )
          ],
        ));
  }
}

class PasswordSection extends StatelessWidget {
  const PasswordSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubtitleDivider(subtitle: 'Password'),
        SizedBox(
          height: getHeightOfLargeButton(),
          width: getWidthOfLargeButton(),
          child: ElevatedButton(
            style: greyButtonStyle,
            child: Text(
              'Change Password',
              style: getNormalTextStyleBlue(),
            ),
            onPressed: () {
              Navigator.pushNamed(context, ChangePasswordPage.routeName);
            },
          ),
        )
      ],
    );
  }
}

class EmailSection extends GetView<ActiveUserController> {
  const EmailSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubtitleDivider(subtitle: 'Email'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.mail,
                color: secondaryColor,
              ),
            ),
            SizedBox(
              width: 0.05 * widthOfScreen,
            ),
            Obx(() => Text(
                  controller.email.value,
                  style: getNormalTextStyleBlue(),
                ))
          ],
        )
      ],
    );
  }
}

/**
 * Alert Dialog specifically built for the username form. It displays
 * an text asking the user if he really wants to change his username
 * before doing so. After that a message is shown with feedback of the
 * operation
 */
class AlertDialogUsername extends StatelessWidget {
  //I couldnt use the dialog defined in profile.dart
  //because of the nature of the function that needs
  //to be executed which needs a param

  AlertDialogUsername({Key? key, required String this.newUsername})
      : super(key: key);

  final String newUsername;

  final ActiveUserController activeUserController =
      Get.find<ActiveUserController>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'Continue with change?',
        style: getNormalTextStyleBlue(),
      ),
      content: Text(
        'Changing username to: ${newUsername}',
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
            await activeUserController
                .changeUsername(newUsername: newUsername)
                .then((value) {
              message = value;
            }).catchError((onError) {
              message = 'Couldn\'t change username';
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
            'Confirm',
            style: getNormalTextStyleYellow(),
          ),
        ),
      ],
    );
  }
}

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
