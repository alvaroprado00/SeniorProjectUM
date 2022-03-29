import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/profile/change_password.dart';
import 'package:flutter/material.dart';

import '../../model/user_custom.dart';
import '../util/components.dart';
import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.dummyUser}) : super(key: key);

  final UserCustom dummyUser;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _controllerUsername;
  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Avatar(nameOfAvatar: getFakeUser().username, size: 200),
            ),
            SizedBox(height: 15),
            SizedBox(
                height: 0.07 * heightOfScreen,
                width: 0.95 * widthOfScreen,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Change Avatar', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
            SubtitleDivider(subtitle: "Username"),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 0.015 * heightOfScreen,
                  left: 0.03 * widthOfScreen,
                  right: 0.03 * widthOfScreen),
              child: TextFormField(
                validator: validatorForEmptyTextField,
                controller: _controllerUsername,
                decoration: getInputDecoration(
                    hintText: widget.dummyUser.username,
                    icon: Icon(
                      Icons.person,
                      color: secondaryColor,
                    )),
              ),
            ),
            SizedBox(
                height: 0.07 * heightOfScreen,
                width: 0.95 * widthOfScreen,
                child: ElevatedButton(
                  onPressed: () {
                    //widget.dummyUser.updateUsername(_controllerUsername.text);
                    Navigator.pop(context);
                  },
                  child: Text('Save', style: getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),
            SubtitleDivider(subtitle: "Password"),
            SizedBox(
                height: 0.07 * heightOfScreen,
                width: 0.95 * widthOfScreen,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangePassword(dummyUser: widget.dummyUser)));
                  },
                  child:
                      Text('Change Password', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
            SubtitleDivider(subtitle: "Email"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 0.015 * heightOfScreen,
                      left: 0.05 * widthOfScreen,
                      right: 0.03 * widthOfScreen),
                  child: Icon(
                    Icons.email,
                    color: secondaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 0.015 * heightOfScreen,
                      left: 0.02 * widthOfScreen,
                      right: 0.03 * widthOfScreen),
                  child: Text(
                    widget.dummyUser.email,
                    style: getNormalTextStyleBlue(),
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: heightOfScreen * 0.2))
          ],
        )),
      ),
    );
  }
}
