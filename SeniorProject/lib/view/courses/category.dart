import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import '../util/cards.dart';

class CategoryPage extends StatelessWidget {
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
                    field1: '0 Courses',
                    field2: '0 Completed',
                    field3: '0 EXP'),
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
                ProgressContainerThreeFields(
                    field1: snapshot.data.length.toString() + ' ' + 'Courses',
                    field2: activeUser!
                            .getCompletedCoursesInCategory(
                                courseIDs: List.of(snapshot.data.keys))
                            .toString() +
                        ' ' +
                        'Completed',
                    field3: activeUser!
                            .getXPInCategory(
                                courseIDs: List.of(snapshot.data.keys))
                            .toString() +
                        ' ' +
                        'EXP'),

                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                getCourseCards(courses: snapshot.data, context: context),
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
getCourseCards(
    {required Map<String, String> courses, required BuildContext context}) {
  //We get as a param a map. Each entry <courseID, courseTitle>

  List<Widget> children = [];
  List<Widget> childrenForRow = [];
  bool isSaved = false;
  bool isCompleted = false;

  int i = 0;
  courses.forEach((key, value) {
    //First we check if the active user has the new-course Saved
    isSaved = activeUser!.isCourseSaved(courseID: key);

    //After that we check if the user has completed the new-course
    isCompleted = activeUser!.isCourseCompleted(courseID: key);

    //We add the new-course to a row
    childrenForRow.add(getCardForCourse(
        isSaved: isSaved,
        isCompleted: isCompleted,
        context: context,
        courseID: key,
        title: value,
        widthOfCard: 0.43 * widthOfScreen,
        heightOfCard: 0.12 * heightOfScreen,
        isTemplate: false));
    if (i == 0) {
      i++;
    } else {
      //Second child of the row. We add it and after create new array for new row
      children.add(Row(
        children: childrenForRow,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ));
      childrenForRow = [];
      i = 0;
    }
  });

  //This means that the number of courses is odd so a new-course has been not added
  //to the children of the column
  if (courses.length % 2 != 0) {
    children.add(Row(
      children: childrenForRow,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ));
  }

  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children);
}
