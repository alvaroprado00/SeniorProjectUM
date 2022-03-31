import 'package:cyber/view/main.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../util/cards.dart';
import '../util/components.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: 0.02 * heightOfScreen, left: widthOfScreen * 0.05),
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
              getCardForNotification(
                  username: 'Alvaro',
                  nameOfCourse: 'Passwords',
                  widthOfCard: 0.925 * widthOfScreen,
                  heightOfCard: 0.12 * heightOfScreen),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.03 * heightOfScreen, bottom: 0.03 * heightOfScreen),
                child: SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomePage.routeName);
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
