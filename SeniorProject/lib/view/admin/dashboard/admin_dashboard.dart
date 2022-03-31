import 'package:cyber/view/admin/new-course/new_course_page.dart';
import 'package:cyber/view/admin/recommended/new_recommended_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);
  static final routeName = '/adminDashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Admin',
          style: getSubheadingStyleWhite(),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: getBackButton(context: context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleDividerAdmin(subtitle: 'Recommended'),
                Padding(
                  padding: EdgeInsets.only(bottom: 30, left: 10, right: 5),
                  child: Text(
                    'Set a recommended course. This question will appear in the user\'s dashboard. ',
                    style: getNormalTextStyleWhite(),
                  ),
                ),
                SizedBox(
                  width: getWidthOfLargeButton(),
                  height: getHeightOfSmallButton(),
                  child: ElevatedButton(
                    style: greyButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, NewRecommendedCoursePage.routeName);
                    },
                    child: Text(
                      'Recommended',
                      style: getNormalTextStyleBlue(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SubtitleDividerAdmin(subtitle: 'Featured'),
                Padding(
                  padding: EdgeInsets.only(bottom: 30, left: 10, right: 5),
                  child: Text(
                    'Set a featured course. Featured courses earn more XP and encourage users to engage and level up. This course appears in the user\'s dashboard. ',
                    style: getNormalTextStyleWhite(),
                  ),
                ),
                SizedBox(
                  width: getWidthOfLargeButton(),
                  height: getHeightOfSmallButton(),
                  child: ElevatedButton(
                    style: greyButtonStyle,
                    onPressed: () {},
                    child: Text(
                      'Featured',
                      style: getNormalTextStyleBlue(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SubtitleDividerAdmin(subtitle: 'Add Content'),
                Padding(
                  padding: EdgeInsets.only(bottom: 30, left: 10, right: 5),
                  child: Text(
                    'Add a course. Choose from 4 different categories and add questions in either multiple choice or fill in the blanks types. ',
                    style: getNormalTextStyleWhite(),
                  ),
                ),
                SizedBox(
                  width: getWidthOfLargeButton(),
                  height: getHeightOfSmallButton(),
                  child: ElevatedButton(
                    style: greyButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(context, NewCoursePage.routeName);
                    },
                    child: Text(
                      'Add',
                      style: getNormalTextStyleBlue(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SubtitleDividerAdmin(subtitle: 'Delete Content'),
                Padding(
                  padding: EdgeInsets.only(bottom: 30, left: 10, right: 5),
                  child: Text(
                    'Delete a course. This action cannot be undone. ',
                    style: getNormalTextStyleWhite(),
                  ),
                ),
                SizedBox(
                  width: getWidthOfLargeButton(),
                  height: getHeightOfSmallButton(),
                  child: ElevatedButton(
                    style: greyButtonStyle,
                    onPressed: () {},
                    child: Text(
                      'Delete',
                      style: getNormalTextStyleBlue(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
