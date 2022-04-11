import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyber/globals.dart' as globals;

import '../util/k_styles.dart';

/**
 * This class is similar to the course description page. However since it needs
 * to make a query to the DB we need to use FutureBuilder and return some content
 * when the future resolves. We could navigate to the CourseDescriptionPage but
 * instead we use the CourseDescriptionContent to show the info of the course
 * directly
 */
class FeaturedCoursePage extends GetView<ActiveUserController> {
  FeaturedCoursePage({Key? key}) : super(key: key);

  final CourseController courseController = CourseController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: courseController.getFeaturedCourse(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //Once I get the new-course I assign its value to a global variable
          // so I can access the info from other pages easily
          globals.activeCourse = snapshot.data;
          globals.activeQuestionNum = 1;
          globals.userProgress = [];

          if (controller.isCurrentCourse(courseID: snapshot.data.id)) {
            globals.activeQuestionNum =
                globals.activeUser!.currentCourse!.progress.length + 1;
            globals.userProgress = globals.activeUser!.currentCourse!.progress;
          }

          return Obx(() => CourseDescriptionContent(
                comesFromFeaturePage: true,
                course: snapshot.data,
                isSaved: controller.isSaved(courseID: snapshot.data.id),
                isCurrentCourse:
                    controller.isCurrentCourse(courseID: snapshot.data.id),
                isCompleted: controller.isCompleted(courseID: snapshot.data.id),
              ));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: getHeadingStyleBlue(),
            ),
          ));
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
