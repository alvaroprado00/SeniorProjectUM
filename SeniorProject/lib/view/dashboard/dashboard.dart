import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static final routeName='/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        title: Text('Welcome Alvaro!', style: getSubheadingStyleBlue(),),
        backgroundColor: tertiaryColor,
        elevation: 0,

      ),
      body: SafeArea(

        child: Padding(
          padding: EdgeInsets.only(
              left: 0.05 * widthOfScreen, right: 0.05 * widthOfScreen),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                Text('Resume Course', style: getNormalTextStyleBlue()),
                Divider(
                  color: primaryColor,
                  thickness: 2,
                ),

                ContainerForCourse(
                    percentage: 73,
                    description: fakeCourseDescription,
                    nameOfCourse: 'Passwords',
                    isResume: true),

                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),

                Text('Recommended', style: getNormalTextStyleBlue()),
                Divider(
                  color: primaryColor,
                  thickness: 2,
                ),
                ContainerForCourse(
                    description: fakeCourseDescription,
                    nameOfCourse: 'NFTs',
                    isResume: false),


                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),


                Text('Categories', style: getNormalTextStyleBlue()),
                Divider(
                  color: primaryColor,
                  thickness: 2,
                ),

                CategoryCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * This class builds an special container shown in the dashboard.
 * It has been built to show both the recommended course and the
 * active course. In case the curse is the active one we need to
 * provide the optional param percentage
 */
class ContainerForCourse extends StatelessWidget {
  const ContainerForCourse({
    this.percentage = 0,
    required String this.description,
    required String this.nameOfCourse,
    required bool this.isResume,
  });

  final String description;
  final String nameOfCourse;
  final bool isResume;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isResume
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nameOfCourse,
                      style: getSubheadingStyleWhite(),
                    ),
                    Text(
                      '${percentage.toString()}%',
                      style: getSubheadingStyleWhite(),
                    )
                  ],
                )
              : Text(
                  nameOfCourse,
                  style: getSubheadingStyleWhite(),
                ),
          isResume
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Completed',
                    style: getSmallTextStyle(),
                  ))
              : SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
          SizedBox(
              width: 0.5 * widthOfScreen,
              child: Text(
                '${description.substring(0, 60)}...',
                style: getSmallTextStyle(),
              )),
          SizedBox(
            height: 0.03 * heightOfScreen,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 0.05 * heightOfScreen,
              width: 0.28 * widthOfScreen,
              child: ElevatedButton(
                style: yellowButtonStyle,
                onPressed: () {
                  print('popo');
                },
                child: Text(
                  isResume ? 'Resume' : 'Start',
                  style: getNormalTextStyleBlue(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCards extends StatelessWidget {
  const CategoryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getCardForCategory(nameOfCategory: 'Devices', widthOfCard: 0.4*widthOfScreen, heightOfCard: 0.2*heightOfScreen),
            getCardForCategory(nameOfCategory: 'Info', widthOfCard: 0.4*widthOfScreen, heightOfCard: 0.2*heightOfScreen),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            getCardForCategory(nameOfCategory: 'Social Media', widthOfCard: 0.4*widthOfScreen, heightOfCard: 0.2*heightOfScreen),
            getCardForCategory(nameOfCategory: 'Web', widthOfCard: 0.4*widthOfScreen, heightOfCard: 0.2*heightOfScreen),
          ],
        )
      ],
    );
  }
}


String fakeCourseDescription =
    'This Course is made to help you learn about the realm of Passwords. How many times have you wondered if your passwords are secure enough? Many times we tend to think that writing a long password with numbers is good enough but is it? If you complete this course you will find the answer to this questions and many more. For example, what characters do you think are the best ones to use? ';
