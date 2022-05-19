import 'package:cyber/main.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';
import '../util/cards.dart';
import '../util/components.dart';
import '../util/k_colors.dart';

class SignUpSummary extends StatelessWidget {
  const SignUpSummary({Key? key}) : super(key: key);

  static final routeName = '/SignUpSummary';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackButton(context: context),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: (0.01 * heightOfScreen),
                    bottom: 0.04 * heightOfScreen,
                    left: widthOfScreen * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'You are here to learn.',
                    style: getSubheadingStyleWhite(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widthOfScreen * 0.05, right: widthOfScreen * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Take courses. Or save them for later.',
                    style: getSubheadingStyleWhite(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widthOfScreen * 0.05,
                    top: heightOfScreen * 0.01,
                    bottom: heightOfScreen * 0.02),
                child: Align(
                  alignment: Alignment.center,
                  child: getCardForCourse(
                      context: context,
                      title: 'Passwords',
                      heightOfCard: 0.11 * heightOfScreen,
                      widthOfCard: 0.4 * widthOfScreen,
                      isTemplate: true),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widthOfScreen * 0.05,
                    bottom: 0.02 * heightOfScreen,
                    right: widthOfScreen * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Browse courses in 4 different categories.',
                    style: getSubheadingStyleWhite(),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCardForCategory(
                          context: context,
                          category: Category.socialMedia,
                          widthOfCard: 0.44 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen,
                          isTemplate: true),
                      getCardForCategory(
                          context: context,
                          category: Category.info,
                          widthOfCard: 0.44 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen,
                          isTemplate: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCardForCategory(
                          context: context,
                          category: Category.web,
                          widthOfCard: 0.44 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen,
                          isTemplate: true),
                      getCardForCategory(
                          context: context,
                          category: Category.info,
                          widthOfCard: 0.44 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen,
                          isTemplate: true),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * heightOfScreen,
                    left: widthOfScreen * 0.05,
                    right: widthOfScreen * 0.05,
                    bottom: 0.02 * heightOfScreen),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Join Groups. Keep Motivated.',
                    style: getSubheadingStyleWhite(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 0.05 * widthOfScreen,
                    right: 0.05 * widthOfScreen,
                    bottom: 0.001 * heightOfScreen),
                child: ListTile(
                  tileColor: tertiaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  leading:
                      Avatar(nameOfAvatar: 'hello', size: widthOfScreen * 0.1),
                  title: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Robo_Learn',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF14213D),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF14213D),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        TextSpan(
                          text: 'completed Passwords. Try it now!',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF14213D),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: getContainerForBadge(
                    nameOfIcon: 'key',
                    size: widthOfScreen * 0.1,
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * heightOfScreen, bottom: 0.03 * heightOfScreen),
                child: SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomePage.routeName,
                            (Route<dynamic> route) => false);
                      },
                      child: Text('Finish', style: getNormalTextStyleBlue()),
                      style: yellowButtonStyle,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
