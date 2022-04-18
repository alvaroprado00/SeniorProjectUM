import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/completed_course.dart';
import '../main.dart';

class CategoryProgress extends StatelessWidget {
  const CategoryProgress({Key? key}) : super(key: key);

  static final routeName = '/categoryProgress';

  @override
  Widget build(BuildContext context) {
    CourseController courseController = CourseController();
    return Scaffold(
        backgroundColor: tertiaryColor,
        appBar: AppBar(
          title: Text(
            categoryToString[activeCourse!.category]!,
            style: getSubheadingStyleBlue(),
          ), //categoryToString[activeCourse!.category]!
          centerTitle: true,
          backgroundColor: tertiaryColor,
          elevation: 0,
          leading: getBackButton(context: context),
        ),
        body: FutureBuilder(
            future: courseController.getCourseNamesFromCategory(
                category: activeCourse!.category),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return CategoryProgressContent(categoryCourses: snapshot.data);
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
            }));
  }
}

class CategoryProgressContent extends GetView<ActiveUserController> {
  const CategoryProgressContent(
      {required Map<String, String> this.categoryCourses});

  final Map<String, String> categoryCourses;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 0.05 * widthOfScreen,
            right: 0.05 * widthOfScreen,
            top: 0.03 * heightOfScreen),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: getHeadingStyleBlue(),
            ),
            Divider(
              thickness: 2,
              color: primaryColor,
            ),
            SizedBox(
              height: 0.01 * heightOfScreen,
            ),
            Obx(() => getProgressInCategory(
                coursesInCategory: categoryCourses,
                userCompletedCourses: controller.completedCourses.value)),
            SizedBox(height: 0.05*heightOfScreen,),
            SizedBox(
              height: getHeightOfLargeButton(),
              width: getWidthOfLargeButton(),
              child: ElevatedButton(
                style: blueButtonStyle,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.routeName, (r) => false);
                },
                child: Text(
                  'Finish',
                  style: getNormalTextStyleWhite(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

getProgressInCategory(
    {required Map<String, String> coursesInCategory,
    required List<CompletedCourse> userCompletedCourses}) {
  List<Widget> childrenOfColumn = [];

  bool isCompleted = false;
  coursesInCategory.forEach((key, value) {
    for (CompletedCourse cc in userCompletedCourses) {

      if (cc.courseID == key) {
        isCompleted = true;
      }
    }
    childrenOfColumn.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getCircle(
            color: isCompleted ? secondaryColor : quinaryColor,
            size: 0.05 * widthOfScreen),
        SizedBox(
          width: 0.05 * widthOfScreen,
        ),
        Text(
          value,
          style: getSubheadingStyleBlue(),
        ),
        SizedBox(
          height: 0.05 * heightOfScreen,
        )
      ],
    ));
    isCompleted=false;
  });

  return SizedBox(
    height: 0.67 * heightOfScreen,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: childrenOfColumn,
      ),
    ),
  );
}
