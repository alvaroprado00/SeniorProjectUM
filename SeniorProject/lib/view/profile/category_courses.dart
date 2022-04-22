import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/model/completed_course.dart';
import 'package:cyber/view/util/cards.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../util/k_values.dart';

class CategoryCourses extends GetView<ActiveUserController> {
  const CategoryCourses({Key? key}) : super(key: key);

  static final routeName = '/categoryCourses';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CategoryCoursesArgs;

    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        backgroundColor: tertiaryColor,
        elevation: 0,
        title: Text(
          args.category,
          style: getSubheadingStyleBlue(),
        ),
        leading: getBackButton(context: context),
        centerTitle: true,
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
                height: 0.03 * heightOfScreen,
              ),
              Obx(() => getAllCourses(
                  coursesInCategory: args.coursesInCategory,
                  context: context,
                  coursesCompleted: controller.completedCourses.value,
                  coursesSaved: controller.coursesSaved.value)),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCoursesArgs {
  const CategoryCoursesArgs(
      {required Map<String, String> this.coursesInCategory,
      required String this.category});

  final Map<String, String> coursesInCategory;
  final String category;
}

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

    if (isSaved || isCompleted) {
      childrenOfRow.add(getCardForCourse(
          courseID: key,
          isCompleted: isCompleted,
          isSaved: isSaved,
          context: context,
          title: value,
          widthOfCard: 0.42 * widthOfScreen,
          heightOfCard: 0.12 * heightOfScreen,
          isTemplate: false));
    }
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
    alignment: WrapAlignment.center,
    runSpacing: 15,
    spacing: 0.04 * widthOfScreen,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: childrenOfRow,
  );
}
