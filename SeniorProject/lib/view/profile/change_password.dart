import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/k_values.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static final String routeName = '/changePasswordPage';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'New Password',
            style: getSubheadingStyleBlue(),
          ),
          centerTitle: true,
          backgroundColor: tertiaryColor,
          leading: getBackButton(context: context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: ChangePasswordForm(),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends GetView<ActiveUserController> {
  ChangePasswordForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerpassword = TextEditingController();
  late TextEditingController _controllerNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //I define the function to execute when pressing the button of the form

    void Function() updatePassword = () {
      if (_formKey.currentState!.validate()) {
        showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogPassword(
                    currentPassword: _controllerpassword.text,
                    newPassword: _controllerNewPassword.text,
                  );
                })
            .then((value) =>
                {_controllerNewPassword.clear(), _controllerpassword.clear()});
      }
    };
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
            left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubtitleDivider(subtitle: 'Current Password'),
              SizedBox(
                height: 0.03 * heightOfScreen,
              ),
              TextFormFieldForPassword(_controllerpassword),
              SizedBox(
                height: 0.05 * heightOfScreen,
              ),
              SubtitleDivider(subtitle: 'New Password'),
              SizedBox(
                height: 0.03 * heightOfScreen,
              ),
              TextFormFieldForPassword(_controllerNewPassword),
              SizedBox(
                height: 0.42 * heightOfScreen,
              ),
              SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: updatePassword,
                  style: yellowButtonStyle,
                  child: Text(
                    'Confirm',
                    style: getNormalTextStyleBlue(),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}

class AlertDialogPassword extends StatelessWidget {
  //I couldnt use the dialog defined in profile.dart
  //because of the nature of the function that needs
  //to be executed which needs a param

  AlertDialogPassword(
      {Key? key,
      required String this.currentPassword,
      required String this.newPassword})
      : super(key: key);

  final String currentPassword;
  final String newPassword;

  final ActiveUserController activeUserController = Get.find<ActiveUserController>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        'Are you sure about this?',
        style: getNormalTextStyleBlue(),
      ),
      content: Text(
        'Your password will change with this action',
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
            await UserController.updatePassword(
                    currentPassword: currentPassword, newPassword: newPassword)
                .then((value) {
              if (value) {
                message = 'Updated password';
              } else {
                message = 'Weak new password';
              }
            }).catchError((onError) {
              message = 'Wrong password for this user';
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
