import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/sign-up/join_group_sign_up.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCreated extends StatelessWidget {
  const ProfileCreated({Key? key}) : super(key: key);

  static final routeName = '/ProfileCreated';

  @override
  Widget build(BuildContext context) {
    final userCreated =
        ModalRoute.of(context)!.settings.arguments as UserCustom;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: 0.05 * heightOfScreen, bottom: 0.05 * heightOfScreen),
                child: Align(
                    child: Text(
                  'Say hello to yourself.',
                  style: getSubheadingStyleWhite(),
                ))),
            Avatar(
                nameOfAvatar: userCreated.username, size: widthOfScreen * 0.5),
            Padding(
              padding: EdgeInsets.only(
                  top: 0.05 * heightOfScreen, bottom: 0.05 * heightOfScreen),
              child: Align(
                  child: Text(
                userCreated.username,
                style: getSubheadingStyleWhite(),
              )),
            ),
            Divider(
              indent: widthOfScreen * 0.025,
              endIndent: widthOfScreen * 0.025,
              color: secondaryColor,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.1 * widthOfScreen,
                  top: 0.03 * heightOfScreen,
                  bottom: 0.03 * heightOfScreen),
              child: Row(children: [
                Icon(
                  CupertinoIcons.mail_solid,
                  color: secondaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    userCreated.email,
                    style: getSmallTextStyle(),
                  ),
                )
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.1 * widthOfScreen),
              child: Row(children: [
                Icon(
                  Icons.lock,
                  color: secondaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    '********',
                    style: getSmallTextStyle(),
                  ),
                )
              ]),
            ),
            Spacer(),
            SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: () => print(
                      Navigator.pushNamed(context, SignUpGroupPage.routeName)),
                  child: Text('Next', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
            Padding(
              padding: EdgeInsets.only(top: 0.03 * heightOfScreen),
              child: getCirclesProgressBar(
                position: 4,
                numberOfCircles: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
