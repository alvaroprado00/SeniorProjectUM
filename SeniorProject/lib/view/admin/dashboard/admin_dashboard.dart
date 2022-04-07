import 'package:cyber/view/admin/check-user-progress/user_progress.dart';
import 'package:cyber/view/admin/delete-course/delete_course.dart';
import 'package:cyber/view/admin/new-course/new_course_page.dart';
import 'package:cyber/view/admin/featured-recommended/new_recommended_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
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
        child: Padding(
          padding: EdgeInsets.only(
              left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.02 * heightOfScreen,
              ),
              Image.asset(
                'assets/images/logoNoTextBetter.png',
                width: 0.5 * widthOfScreen,
                height: 0.2 * heightOfScreen,
              ),
              SizedBox(
                height: 0.03 * heightOfScreen,
              ),
              Text(
                'What do you want to do?',
                style: getSubheadingStyleWhite(),
              ),
              SizedBox(
                height: 0.05 * heightOfScreen,
              ),
              Divider(
                color: secondaryColor,
                thickness: 2,
                indent: 0.07 * widthOfScreen,
                endIndent: 0.07 * widthOfScreen,
              ),
              SizedBox(
                height: 0.04 * heightOfScreen,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0.07 * widthOfScreen, 0, 0.07 * widthOfScreen, 0),
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
                          text: 'User progress',
                          route: UserProgressPage.routeName),
                    ]),
              )
            ],
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
