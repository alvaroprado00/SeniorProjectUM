import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/profile/category_badges.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../config/fixed_values.dart';
import '../../controller/active_user_controller.dart';
import '../../model/badge.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';

class AllBadgesPage extends StatelessWidget {
  const AllBadgesPage({
    Key? key,
  }) : super(key: key);

  static final routeName = '/allBadges';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Badges",
          style: getSubheadingStyleBlue(),
        ),
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
            BadgesFromCategory(category: Category.info),
            SizedBox(height: 0.05 * heightOfScreen),
            BadgesFromCategory(category: Category.web),
            SizedBox(height: 0.05 * heightOfScreen),
            BadgesFromCategory(category: Category.socialMedia),
            SizedBox(height: 0.05 * heightOfScreen),
            BadgesFromCategory(category: Category.devices),
            SizedBox(height: 0.05 * heightOfScreen),
          ],
        )),
      ),
    );
  }
}

class BadgesFromCategory extends StatelessWidget {
  const BadgesFromCategory({Key? key, required Category this.category})
      : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubtitleDivider(subtitle: categoryToString[category]!),
        BadgesContent(
          category: category,
        )
      ],
    );
  }
}

class BadgesContent extends GetView<ActiveUserController> {
  const BadgesContent({Key? key, required Category this.category})
      : super(key: key);

  final Category category;
  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();
    return FutureBuilder(
      future: cc.getCourseNamesFromCategory(category: category),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //The snapshot is a map with entries <courseID, courseName>
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 0.05 * heightOfScreen),
                Text(
                  'No courses in category',
                  style: getSubheadingStyleBlue(),
                )
              ],
            );
          } else {
            return Obx(() => getRowOfBadges(
                coursesInCategory: snapshot.data,
                context: context,
                category: category,
                userBadges: controller.collectedBadges));
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error when getting courses from category'),
          );
        } else {
          return SizedBox(
              height: 0.01 * heightOfScreen,
              child: LinearProgressIndicator(
                color: secondaryColor,
              ));
        }
      },
    );
  }
}

getRowOfBadges(
    {required Map<String, String> coursesInCategory,
    required BuildContext context,
    required Category category,
    required List<Badge> userBadges}) {
  List<Widget> childrenOfRow = [];

  //Add a maximum of 3 badges
  for (int i = 0; i < userBadges.length; i++) {
    Badge userBadge = userBadges[i];
    if (coursesInCategory.containsKey(userBadge.courseID) &&
        childrenOfRow.length < 4) {
      childrenOfRow.add(getIconButtonForBadge(
          badge: userBadge,
          nameOfCourse: coursesInCategory[userBadge.courseID]!,
          size: 0.1 * heightOfScreen,
          context: context));
    }
  }

  int numberOfBadges = childrenOfRow.length;

  //In case there are no badges I show a message
  if (numberOfBadges == 0) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: heightOfScreen * 0.05,
        ),
        Text(
          'No badges Earned in ${categoryToString[category]!}',
          style: getSubheadingStyleBlue(),
        ),
      ],
    );
  }

  //I add grey circles to complete the row

  if (numberOfBadges < 3) {
    for (int i = 0; i < (3 - numberOfBadges); i++) {
      childrenOfRow
          .add(getCircle(color: quinaryColor, size: 0.1 * heightOfScreen));
    }
  }

  //The last badge will be the button to go to the next page

  childrenOfRow.add(getIconButtonShowMore(
      context: context,
      size: 0.1 * heightOfScreen,
      todo: () {
        Navigator.pushNamed(context, CategoryBadges.routeName,
            arguments: CategoryBadgesArgs(
                coursesInCategory: coursesInCategory, category: category));
      }));

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: childrenOfRow,
  );
}

Widget getIconButtonForBadge(
    {required Badge badge,
    required String nameOfCourse,
    required double size,
    required BuildContext context}) {
  return Container(
    decoration: BoxDecoration(
      color: primaryColor,
      shape: BoxShape.circle,
    ),
    width: size,
    height: size,
    child: IconButton(
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return BadgeDialog(badge: badge, nameOfCourse: nameOfCourse);
            });
      },
      icon: Icon(
        FontAwesomeIconsMap[badge.picture],
        color: secondaryColor,
        size: 0.4 * size,
      ),
    ),
  );
}

class BadgeDialog extends StatelessWidget {
  const BadgeDialog(
      {Key? key, required Badge this.badge, required String this.nameOfCourse})
      : super(key: key);

  final Badge badge;
  final String nameOfCourse;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        nameOfCourse,
        style: getSubheadingStyleBlue(),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          getContainerForBadge(
              nameOfIcon: badge.picture, size: 0.3 * heightOfScreen),
          SizedBox(height: heightOfScreen * 0.05),
          Text(
            'Earned: ${badge.timeEarnedToString()}',
            style: getNormalTextStyleBlue(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

getIconButtonShowMore(
    {required BuildContext context,
    required double size,
    required void Function() todo}) {
  return Padding(
    padding: const EdgeInsets.only(left: 6, right: 6),
    child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
        ),
        child: IconButton(
            onPressed: todo,
            icon: Icon(
              Icons.add,
              color: secondaryColor,
            ))),
  );
}
