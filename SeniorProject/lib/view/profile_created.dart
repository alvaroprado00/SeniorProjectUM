import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/join_group_sign_up.dart';
import 'package:cyber/view/k_styles.dart';
import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'components.dart';
import 'k_values.dart';


class ProfileCreated extends StatelessWidget {

  const ProfileCreated({Key? key}) : super(key: key);

  static final routeName= '/ProfileCreated';

  @override
  Widget build(BuildContext context) {

    final userCreated = ModalRoute.of(context)!.settings.arguments as UserCustom;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top:0.05*heightOfScreen, bottom:0.05*heightOfScreen),
              child: Align(child: Text('Say hello to yourself.', style: getSubheadingStyleWhite(),))
            ),
            
            Avatar(url: 'https://robohash.org/${userCreated.username}', size: widthOfScreen*0.5),

            Padding(
              padding: EdgeInsets.only(top:0.05*heightOfScreen, bottom:0.05*heightOfScreen),
                child: Align(child: Text(userCreated.username, style: getSubheadingStyleWhite(),)),
            ),

            Divider(indent: widthOfScreen*0.025, endIndent: widthOfScreen*0.025, color: secondaryColor,thickness: 1,),

            Padding(
              padding: EdgeInsets.only( left: 0.1*widthOfScreen , top:0.03*heightOfScreen, bottom:0.03*heightOfScreen),
              child: Row(children:[Icon(Icons.mail, color: secondaryColor,), Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(userCreated.email, style: getSmallTextStyle(),),
              )]),
            ),

            Padding(
              padding: EdgeInsets.only( left: 0.1*widthOfScreen,  bottom:0.17*heightOfScreen),
              child: Row(children:[Icon(Icons.lock, color: secondaryColor,), Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text('********', style: getSmallTextStyle(), ),
              )]),
            ),

            SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: () => print(Navigator.pushNamed(context, SignUpJoinGroup.routeName)),
                  child: Text('Next', style: getNormalTextStyleBlue()),
                  style: largeGreyButtonStyle,
                )),

            Padding(
              padding: EdgeInsets.only(top: 0.03*heightOfScreen),
              child: getCirclesProgressBar(position:4, numberOfCircles: 5,widthOfScreen: widthOfScreen),
            ),
          ],
        ),
      ),
    );
  }
}
