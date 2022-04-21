import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/view/profile/category_courses.dart';
import 'package:cyber/view/util/cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class AllCoursesPage extends StatelessWidget {
  const AllCoursesPage({Key? key}) : super(key: key);

  static final String routeName = '/allCourses';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        title: Text(
          'My Courses',
          style: getSubheadingStyleBlue(),
        ),
        elevation: 0,
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 0.02 * heightOfScreen,
              ),
              UserProgress(),
              SizedBox(
                height: 0.02 * heightOfScreen,
              ),
              CategoryCardsForUser(category: Category.info),
              SizedBox(
                height: 0.02 * heightOfScreen,
              ),
              CategoryCardsForUser(category: Category.web),
              SizedBox(
                height: 0.02 * heightOfScreen,
              ),
              CategoryCardsForUser(category: Category.socialMedia),
              SizedBox(
                height: 0.02 * heightOfScreen,
              ),
              CategoryCardsForUser(category: Category.devices),
              SizedBox(
                height: 0.05 * heightOfScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProgress extends GetView<ActiveUserController> {
  UserProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
      child: Obx(() => ProgressContainerThreeFields(
          field1: '${controller.coursesSaved.value.length.toString()} Saved',
          field2: '${controller.getTotalPoints().toString()} Points',
          field3:
              '${controller.completedCourses.value.length.toString()} Completed')),
    );
  }
}

class CategoryCardsForUser extends StatelessWidget {
  const CategoryCardsForUser({Key? key, required Category this.category})
      : super(key: key);

  final Category category;
  @override
  Widget build(BuildContext context) {
    //I create a course controller so I can call then DB in search for all the courses in a category
    //I just need to get from DB a map with <courseID-Name> so then I can build the cards
    //Each course cards needs the name of the course, the course ID and info about if it is
    //completed or saved. With that map we can get all that info using also the info of the active user

    CourseController cc = CourseController();

    return FutureBuilder(
      future: cc.getCourseNamesFromCategory(category: category),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CategoryContent(
            coursesInCategory: snapshot.data,
            nameOfCategory: categoryToString[category]!,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: getHeadingStyleBlue(),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
      },
    );
  }
}

class CategoryContent extends StatelessWidget {
  const CategoryContent(
      {Key? key,
      required Map<String, String> this.coursesInCategory,
      required String this.nameOfCategory})
      : super(key: key);

  final Map<String, String> coursesInCategory;
  final String nameOfCategory;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
          child: SubtitleDivider(
            subtitle: nameOfCategory,
          ),
        ),
        getCards(context: context),
      ],
    );
  }

  getCards({required BuildContext context}) {
    List<Widget> childrenOfRow = [];

    //I get an instance of the activeUserController

    ActiveUserController activeUserController =
        Get.find<ActiveUserController>();

    //If no courses in category, notify user
    if (coursesInCategory.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No courses in category',
              style: getNormalTextStyleBlue(),
            ),
          )
        ],
      );
    }

    coursesInCategory.forEach((key, value) {
      //The max number of courses we are going to add is 3
      if ((activeUserController.isCompleted(courseID: key) ||
              activeUserController.isSaved(courseID: key)) &&
          childrenOfRow.length <= 3) {
        //In case the user has either completed or saved the course we display the info
        childrenOfRow.add(Obx(() => getCardForCourse(
            courseID: key,
            isCompleted: activeUserController.isCompleted(courseID: key),
            isSaved: activeUserController.isSaved(courseID: key),
            context: context,
            title: value,
            widthOfCard: 0.42 * widthOfScreen,
            heightOfCard: 0.12 * heightOfScreen,
            isTemplate: false)));
      }
    });

    if (childrenOfRow.length == 0) {
      //If we dont even have one course we display a text
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No courses completed or saved',
              style: getNormalTextStyleBlue(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }

    //If we dont have enough we place a placeholder
    if (childrenOfRow.length < 3) {
      int numberOfPlaceHolders = 3 - childrenOfRow.length;
      for (int i = 0; i < numberOfPlaceHolders; i++) {
        childrenOfRow.add(getCourseCardPlaceHolder());
      }
    }

    //The last thing we need to add is see all button
    childrenOfRow.add(getSeeAllButton(
        coursesInCategory: coursesInCategory,
        categoryName: nameOfCategory,
        context: context));

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 15,
      spacing: 0.04 * widthOfScreen,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: childrenOfRow,
    );
  }

  /**
   * A function to get a button to navigate when pressed to a page
   * where you can see all the
   */
  getSeeAllButton(
      {required BuildContext context,
      required Map<String, String> coursesInCategory,
      required String categoryName}) {
    return Container(
      width: 0.42 * widthOfScreen,
      height: 0.12 * heightOfScreen,
      decoration: BoxDecoration(
          color: quinaryColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CategoryCourses.routeName,
              arguments: CategoryCoursesArgs(
                  coursesInCategory: coursesInCategory,
                  category: categoryName));
        },
        icon: Icon(CupertinoIcons.add,
            color: secondaryColor, size: 0.06 * heightOfScreen),
      ),
    );
  }
}
