import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/current_course.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

import '../useful/cards.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static final routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tertiaryColor,
        body: FutureBuilder(
          future: UserController.getActiveUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              //This is the moment to save our active user in the global variable

              activeUser=snapshot.data;
              return ContentForDashboard(user: snapshot.data);
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
        ));
  }
}

/**
 * Class to show the info for the Dashboard. It receives the active user as a
 * param since the content varies depending on the user.
 */

class ContentForDashboard extends StatelessWidget {
  const ContentForDashboard({required UserCustom this.user});
  final UserCustom user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 0.05 * widthOfScreen, right: 0.05 * widthOfScreen),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${user.username}!',
                style: getSubheadingStyleBlue(),
              ),
              user.currentCourse == null
                  ? SizedBox(
                      height: 0,
                    )
                  : ResumeCourseContent(currentCourse: user.currentCourse!),
              SizedBox(
                height: 0.05 * heightOfScreen,
              ),
              RecommendedCourseContent(),
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
    );
  }
}

/**
 * This class when built shows a card for the recommended course.
 * It has to first execute the future to search for it in the DB
 */

class RecommendedCourseContent extends StatefulWidget {
  const RecommendedCourseContent({Key? key}) : super(key: key);

  @override
  _RecommendedCourseContentState createState() =>
      _RecommendedCourseContentState();
}

class _RecommendedCourseContentState extends State<RecommendedCourseContent> {
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
                Text('Recommended', style: getNormalTextStyleBlue()),
                Divider(
                  color: primaryColor,
                  thickness: 2,
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
 * It is created specifying an active course from the User.
 * The future consists on searching for that course in the database
 */

class ResumeCourseContent extends StatefulWidget {
  final CurrentCourse currentCourse;

  const ResumeCourseContent({required CurrentCourse this.currentCourse});

  @override
  _ResumeCourseContentState createState() => _ResumeCourseContentState();
}

class _ResumeCourseContentState extends State<ResumeCourseContent> {
  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();

    return FutureBuilder(
      future: cc.getCourseByID(id: widget.currentCourse.courseID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
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
                percentage: (widget.currentCourse.progress.length) /
                    (snapshot.data.numberOfQuestions) *
                    100,
                courseID: widget.currentCourse.courseID,
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
 * It has been built to show both the recommended course and the
 * active course. In case the course is the active one we need to
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
  final double percentage;
  final String courseID;

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
                  Navigator.pushNamed(context, CourseDescription.routeName, arguments: courseID);
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
                widthOfCard: 0.4 * widthOfScreen,
                heightOfCard: 0.2 * heightOfScreen,
                isTemplate: false),
            getCardForCategory(
                context: context,
                category: Category.info,
                widthOfCard: 0.4 * widthOfScreen,
                heightOfCard: 0.2 * heightOfScreen,
                isTemplate: false),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getCardForCategory(
                context: context,
                category: Category.socialMedia,
                widthOfCard: 0.4 * widthOfScreen,
                heightOfCard: 0.2 * heightOfScreen,
                isTemplate: false),
            getCardForCategory(
                context: context,
                category: Category.web,
                widthOfCard: 0.4 * widthOfScreen,
                heightOfCard: 0.2 * heightOfScreen,
                isTemplate: false),
          ],
        )
      ],
    );
  }
}
