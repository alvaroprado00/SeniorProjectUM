import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';
import 'k_styles.dart';

class SignUpSummary extends StatelessWidget {
  const SignUpSummary({Key? key}) : super(key: key);

  static final routeName = '/SignUpSummary';

  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    height = height - padding.top;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        //This is to solve the problem of the overflow caused by the keyboard
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: AlignmentDirectional.centerStart,
                child: getBackButton(
                    context: context, heightOfScreen: height)),
            Padding(
              padding: EdgeInsets.only(
                  top: (0.01 * height), bottom: (0.05 * height), left: width*0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You are here to learn.',
                  style: getSubheadingStyleWhite(widthOfScreen: width),
                ),
              ),
            ),

            Padding(
              padding:EdgeInsets.only(left: width*0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Take Courses. Or save them for later.',
                  style: getSubheadingStyleWhite(widthOfScreen: width),
                ),
              ),
            ),

            Padding(
              padding:EdgeInsets.only(left: width*0.04, top:height*0.03, bottom: height*0.03),
              child: Align(
                alignment: Alignment.centerLeft,
                child: getCardForUnsavedCourse(nameOfCourse: 'Passwords', height: 0.05*height, width: 0.4*width),
              ),
            ),

            Padding(
              padding:EdgeInsets.only(left: width*0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Browse courses in four different categories.',
                  style: getSubheadingStyleWhite(widthOfScreen: width),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
