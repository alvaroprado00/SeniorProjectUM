import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../model/completed_course.dart';
import '../util/cards.dart';

class CategoryPage extends GetView<ActiveUserController> {
  const CategoryPage({Key? key}) : super(key: key);

  static const routeName = '/category';

  @override
  Widget build(BuildContext context) {
    // We are going to specify the category when navigating to this page
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    //We create a courseController to be able to use its methods
    final CourseController courseController = CourseController();

    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        title: Text(
          categoryToString[category]!,
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        backgroundColor: tertiaryColor,
        leading: getBackButton(context: context),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: courseController.getCourseNamesFromCategory(
          category: category,
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children = [];

          //The snapshot.data should be a map. Each entry is the courseID and
          //the new-course title of one new-course from the category

          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              children = [
                ProgressContainerThreeFields(
                    field1: '0 Courses', field2: '0 Completed', field3: '0 XP'),
                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                Center(
                    child: Text(
                  'No courses in ${categoryToString[category]!}',
                  style: getNormalTextStyleBlue(),
                ))
              ];
            } else {
              children = [
                //The active user stored in the globals file is used to see
                //his progress in the category
                Obx(() => ProgressContainerThreeFields(
                    field1: snapshot.data.length.toString() + ' ' + 'Courses',
                    field2: controller
                            .getCompletedCoursesInCategory(
                                courseIDs: List.of(snapshot.data.keys))
                            .toString() +
                        ' ' +
                        'Completed',
                    field3: controller
                            .getXPInCategory(
                                courseIDs: List.of(snapshot.data.keys))
                            .toString() +
                        ' ' +
                        'XP')),

                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                Obx(() => getAllCourses(
                    coursesInCategory: snapshot.data,
                    context: context,
                    coursesCompleted: controller.completedCourses,
                    coursesSaved: controller.coursesSaved)),
              ];
            }

            return Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error}',
                style: getHeadingStyleBlue(),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          }
        },
      ),
    );
  }
}

/**
 * This method is used to get the cards of the courses that are specified in
 * the param courses. The way it returns the courses is a column in which the children
 * are rows formed of two courses.
 */
Widget getAllCourses(
    {required Map<String, String> coursesInCategory,
    required List<String> coursesSaved,
    required List<CompletedCourse> coursesCompleted,
    required BuildContext context}) {
  List<Widget> childrenOfRow = [];

  coursesInCategory.forEach((key, value) {
    bool isCompleted = false;
    bool isSaved = coursesSaved.contains(key);
    for (CompletedCourse cc in coursesCompleted) {
      if (cc.courseID == key) {
        isCompleted = true;
      }
    }

    childrenOfRow.add(getCardForCourse(
        courseID: key,
        isCompleted: isCompleted,
        isSaved: isSaved,
        context: context,
        title: value,
        widthOfCard: 0.42 * widthOfScreen,
        heightOfCard: 0.12 * heightOfScreen,
        isTemplate: false));
  });

  if (childrenOfRow.isEmpty) {
    return Center(
      child: Text(
        'No Courses Earned yet',
        style: getSubheadingStyleBlue(),
      ),
    );
  }

  return Wrap(
    //alignment: WrapAlignment.center,
    runSpacing: 15,
    spacing: 0.04 * widthOfScreen,
    runAlignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: childrenOfRow,
  );
}
