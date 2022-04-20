import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/model/current_course.dart';
import 'package:cyber/view/admin/dashboard/admin_dashboard.dart';
import 'package:cyber/view/courses/category.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/cards.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  static final routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return ContentForDashboard();
  }
}

/**
 * Class to show the info for the Dashboard. It receives the active user as a
 * param since the content varies depending on the user.
 */

class ContentForDashboard extends GetView<ActiveUserController> {
  const ContentForDashboard();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          floatingActionButton: controller.isAdmin.value ? AdminButton() : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          backgroundColor: tertiaryColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Welcome ${controller.username.value}!',
              style: getSubheadingStyleBlue(),
            ),
            /*Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: quaternaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  'Welcome ${controller.username.value}!',
                  style: getSubheadingStyleBlue(),
                ),
              ),
            ),*/
            leadingWidth: 0,
            backgroundColor: tertiaryColor,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: primaryColor,
              fontSize: 0.08 * widthOfScreen,
              fontWeight: FontWeight.w500,
              fontFamily: 'roboto',
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.currentCourse.value == null
                        ? SizedBox(
                            height: 0,
                          )
                        : ResumeCourseContent(
                            currentCourse: controller.currentCourse.value!),
                    SizedBox(
                      height: 0.03 * heightOfScreen,
                    ),
                    RecommendedCourseContent(),
                    SizedBox(
                      height: 0.03 * heightOfScreen,
                    ),
                    SubtitleDivider(
                      subtitle: 'Categories',
                    ),
                    CategoryCards(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

/**
 * This class when built displays a floating button only available for the admin
 * It redirects the user to the admin pages
 */
class AdminButton extends StatelessWidget {
  const AdminButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        hoverColor: primaryColor,
        hoverElevation: 20,
        onPressed: () {
          Navigator.pushNamed(context, AdminDashboardPage.routeName);
        },
        child: const Icon(
          Icons.admin_panel_settings,
          color: tertiaryColor,
          size: 32,
        ),
        backgroundColor: secondaryColor,
      ),
    );
  }
}

/**
 * This class when built shows a card for the recommended new-course.
 * It has to first execute the future to search for it in the DB
 */

class RecommendedCourseContent extends StatelessWidget {
  const RecommendedCourseContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();

    return FutureBuilder(
      future: cc.getRecommendedCourse(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleDivider(
                  subtitle: 'Recommended',
                ),
                ContainerForCourse(
                    courseID: snapshot.data.id,
                    description: snapshot.data.description,
                    nameOfCourse: snapshot.data.title,
                    isResume: false),
              ]);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: getHeadingStyleBlue(),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/**
 * This is a stateful widget that builds using a FutureBuilder
 * It is created specifying an active new-course from the User.
 * The future consists on searching for that new-course in the database
 */

class ResumeCourseContent extends StatelessWidget {
  const ResumeCourseContent({required CurrentCourse this.currentCourse});
  final CurrentCourse currentCourse;

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();

    return FutureBuilder(
      future: cc.getCourseByID(id: currentCourse.courseID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleDivider(subtitle: 'Resume Course'),
                ContainerForCourse(
                    percentage: ((currentCourse.progress.length) /
                            (snapshot.data.numberOfQuestions) *
                            100)
                        .round(),
                    courseID: currentCourse.courseID,
                    description: snapshot.data.description,
                    nameOfCourse: snapshot.data.title,
                    isResume: true),
              ]);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: getHeadingStyleBlue(),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/**
 * This class builds an special container shown in the dashboard.
 * It has been built to show both the recommended new-course and the
 * active new-course. In case the new-course is the active one we need to
 * provide the optional param percentage
 */
class ContainerForCourse extends StatelessWidget {
  const ContainerForCourse({
    this.percentage = 0,
    required String this.description,
    required String this.nameOfCourse,
    required String this.courseID,
    required bool this.isResume,
  });

  final String description;
  final String nameOfCourse;
  final bool isResume;
  final int percentage;
  final String courseID;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  height: 0.02 * heightOfScreen,
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
                  Navigator.pushNamed(context, CourseDescription.routeName,
                      arguments: courseID);
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

/**
 * This class when built shows a grid with 4 cards. One for each
 * category
 */

class CategoryCards extends StatelessWidget {
  const CategoryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getCardForCategory(
                context: context,
                category: Category.devices,
                widthOfCard: 0.43 * widthOfScreen,
                heightOfCard: 0.15 * heightOfScreen,
                routeToNavigate: CategoryPage.routeName,
                arguments: Category.devices,
                isTemplate: false),
            getCardForCategory(
                context: context,
                category: Category.info,
                widthOfCard: 0.43 * widthOfScreen,
                heightOfCard: 0.15 * heightOfScreen,
                routeToNavigate: CategoryPage.routeName,
                arguments: Category.info,
                isTemplate: false),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getCardForCategory(
                context: context,
                category: Category.socialMedia,
                widthOfCard: 0.43 * widthOfScreen,
                heightOfCard: 0.15 * heightOfScreen,
                routeToNavigate: CategoryPage.routeName,
                arguments: Category.socialMedia,
                isTemplate: false),
            getCardForCategory(
                context: context,
                category: Category.web,
                widthOfCard: 0.43 * widthOfScreen,
                heightOfCard: 0.15 * heightOfScreen,
                routeToNavigate: CategoryPage.routeName,
                arguments: Category.web,
                isTemplate: false),
          ],
        ),
        SizedBox(height: heightOfScreen * 0.1)
      ],
    );
  }
}
