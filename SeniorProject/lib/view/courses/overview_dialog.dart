import 'package:cyber/globals.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../util/k_styles.dart';


/**
 * This class is used to show an alert dialog in the overview page
 * It can be used to show the user he has leveled up or it can be used
 * to show the badge that he has earned
 *
 */
class OverviewDialog extends StatelessWidget {
  const OverviewDialog({required bool this.isBadge});

  final bool isBadge;
  @override
  Widget build(BuildContext context) {
     return AlertDialog(
       title: Text(isBadge? 'You earned a new Badge!':'Level UP!', style: getSubheadingStyleBlue(),textAlign: TextAlign.center,),

      content: isBadge? BadgeContent():LevelUpContent(),
      insetPadding: EdgeInsets.all(10),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[

        SizedBox(
            height: getHeightOfSmallButton(),
            width: getWidthOfSmallButton(),
            child: ElevatedButton(
              onPressed: () {
                print('Popo');
              },
              child: Text(isBadge? 'All Badges': 'All Avatars', style: getNormalTextStyleBlue()),
              style: greyButtonStyle,
            )),
      ],
    );
  }
}


class LevelUpContent extends StatelessWidget {
  const LevelUpContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Avatar(nameOfAvatar:activeUser!.collectedAvatars.last, size:0.2*heightOfScreen),
        SizedBox(height: 0.05*heightOfScreen,),

        Text('Avatar ID:${activeUser!.collectedAvatars.last}',style: getNormalTextStyleBlue(),),
      ],
    );
  }
}

class BadgeContent extends StatelessWidget {
  const BadgeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getContainerForBadge(nameOfIcon: activeUser!.collectedBadges.last.picture, size: 0.2*heightOfScreen),
        SizedBox(height: 0.05*heightOfScreen,),
        Text('Course:${activeCourse!.title}',style: getNormalTextStyleBlue(),),
      ],
    );
  }
}

