import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/user_custom.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.dummyUser}) : super(key: key);

  final UserCustom dummyUser;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _controllerPassword;
  late TextEditingController _controllerNewPassword;
  @override
  void initState() {
    super.initState();
    _controllerPassword = TextEditingController();
    _controllerNewPassword = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerPassword.dispose();
    _controllerNewPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Password",
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SubtitleDivider(subtitle: "Current Password"),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 0.03 * heightOfScreen,
                  left: 0.03 * widthOfScreen,
                  right: 0.03 * widthOfScreen),
              child: TextFormFieldForPassword(_controllerPassword),
            ),
            SubtitleDivider(subtitle: "New Password"),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 0.03 * heightOfScreen,
                  left: 0.03 * widthOfScreen,
                  right: 0.03 * widthOfScreen),
              child: TextFormFieldForPassword(_controllerNewPassword),
            ),
            SizedBox(
                height: 0.07 * heightOfScreen,
                width: 0.95 * widthOfScreen,
                child: ElevatedButton(
                  onPressed: () {},
                  child:
                      Text('Change Password', style: getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),
          ],
        ),
      ),
    );
  }
}
