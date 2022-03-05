import 'package:cyber/view/dashboard/dashboard.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

import '../useful/components.dart';

class SignUpSummary extends StatelessWidget {
  const SignUpSummary({Key? key}) : super(key: key);

  static final routeName = '/SignUpSummary';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        //This is to solve the problem of the overflow caused by the keyboard
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: getBackButton(
                      context: context)),
              Padding(
                padding: EdgeInsets.only(
                    top: (0.015 * heightOfScreen),
                    bottom: 0.04 * heightOfScreen,
                    left: widthOfScreen * 0.08),
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
                    left: widthOfScreen * 0.08, right: widthOfScreen * 0.1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Take Courses. Or save them for later.',
                    style: getSubheadingStyleWhite(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widthOfScreen * 0.08,
                    top: heightOfScreen * 0.03,
                    bottom: heightOfScreen * 0.03),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: getCardForUnsavedCourse(
                      nameOfCourse: 'Passwords',
                      heightOfCard: 0.11 * heightOfScreen,
                      widthOfCard: 0.4 * widthOfScreen),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widthOfScreen * 0.08,
                    bottom: 0.03 * heightOfScreen,
                    right: widthOfScreen * 0.08),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Browse courses in four different categories.',
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
                          nameOfCategory: 'Social Media',
                          widthOfCard: 0.4 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen),
                      getCardForCategory(
                          nameOfCategory: 'Web',
                          widthOfCard: 0.4 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCardForCategory(
                          nameOfCategory: 'Devices',
                          widthOfCard: 0.4 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen),
                      getCardForCategory(
                          nameOfCategory: 'Information',
                          widthOfCard: 0.4 * widthOfScreen,
                          heightOfCard: 0.09 * heightOfScreen),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top:0.03*heightOfScreen, left: widthOfScreen * 0.08, right:  widthOfScreen * 0.1, bottom:0.03*heightOfScreen ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Join Groups. Keep Motivated',
                    style: getSubheadingStyleWhite(),
                  ),
                ),
              ),

              getCardForNotification(username:'Alvaro', nameOfCourse: 'Passwords', widthOfCard: 0.9*widthOfScreen, heightOfCard: 0.13*heightOfScreen),

              Padding(
                padding: EdgeInsets.only(top:0.03*heightOfScreen, bottom:0.03*heightOfScreen ),
                child: SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, DashboardPage.routeName);
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
