import 'package:cyber/view/admin/check-user-progress/user_progress.dart';
import 'package:cyber/view/admin/delete-course/delete_course.dart';
import 'package:cyber/view/admin/featured-recommended/new_recommended_page.dart';
import 'package:cyber/view/admin/new-course/new_course_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../featured-recommended/new_featured_page.dart';

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
        /* child: SingleChildScrollView(
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
            ),*/
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                Icon(
                  Icons.admin_panel_settings_outlined,
                  color: secondaryColor,
                  size: 32,
                ),
                // Image.asset(
                //   'assets/images/IconGrid.png',
                //   width: 0.5 * widthOfScreen,
                //   height: 0.2 * heightOfScreen,
                // ),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                Text(
                  'CHOOSE AN OPTION',
                  style: getNormalTextStyleYellowBold(),
                ),

                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                Divider(
                  color: secondaryColor,
                  thickness: 1,
                  indent: 0.03 * widthOfScreen,
                  endIndent: 0.03 * widthOfScreen,
                ),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0.03 * widthOfScreen, 0, 0.03 * widthOfScreen, 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ButtonToNavigate(
                            text: 'Add Course', route: NewCoursePage.routeName),
                        SizedBox(
                          height: 0.03 * heightOfScreen,
                        ),
                        ButtonToNavigate(
                            text: 'Delete Course',
                            route: DeleteCoursePage.routeName),
                        SizedBox(
                          height: 0.03 * heightOfScreen,
                        ),
                        ButtonToNavigate(
                            text: 'Recommended Course',
                            route: UpdateRecommendedCoursePage.routeName),
                        SizedBox(
                          height: 0.03 * heightOfScreen,
                        ),
                        ButtonToNavigate(
                            text: 'Featured Course',
                            route: UpdateFeaturedCoursePage.routeName),
                        SizedBox(
                          height: 0.03 * heightOfScreen,
                        ),
                        ButtonToNavigate(
                            text: 'User Progress',
                            route: UserProgressPage.routeName),
                      ]),
                ),
                SizedBox(
                  height: 0.03 * heightOfScreen,
                ),
                Divider(
                  color: secondaryColor,
                  thickness: 1,
                  indent: 0.03 * widthOfScreen,
                  endIndent: 0.03 * widthOfScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonToNavigate extends StatelessWidget {
  const ButtonToNavigate(
      {Key? key, required String this.text, required String this.route})
      : super(key: key);

  final String text;
  final String route;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidthOfLargeButton(),
      height: getHeightOfSmallButton(),
      child: ElevatedButton(
        style: greyButtonStyle,
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: getNormalTextStyleBlue(),
        ),
      ),
    );
  }
}
