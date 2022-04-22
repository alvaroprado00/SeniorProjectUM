import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/view/profile/all_badges.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/badge.dart';
import '../util/k_values.dart';

class CategoryBadges extends GetView<ActiveUserController> {
  const CategoryBadges({Key? key}) : super(key: key);

  static final routeName = '/categoryBadges';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CategoryBadgesArgs;

    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        backgroundColor: tertiaryColor,
        elevation: 0,
        title: Text(
          categoryToString[args.category]!,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.03 * heightOfScreen,
              ),
              Obx(() => getAllBadges(
                  coursesInCategory: args.coursesInCategory,
                  context: context,
                  userBadges: controller.collectedBadges.value)),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryBadgesArgs {
  const CategoryBadgesArgs(
      {required Map<String, String> this.coursesInCategory,
      required Category this.category});

  final Map<String, String> coursesInCategory;
  final Category category;
}

Widget getAllBadges(
    {required Map<String, String> coursesInCategory,
    required BuildContext context,
    required List<Badge> userBadges}) {
  List<Widget> childrenOfRow = [];

  for (Badge b in userBadges) {
    if (coursesInCategory.containsKey(b.courseID)) {
      childrenOfRow.add(getIconButtonForBadge(
          badge: b,
          nameOfCourse: coursesInCategory[b.courseID]!,
          size: 0.1 * heightOfScreen,
          context: context));
    }
  }

  if (childrenOfRow.isEmpty) {
    return Center(
      child: Text(
        'No badges Earned yet',
        style: getSubheadingStyleBlue(),
      ),
    );
  }

  return Wrap(
    children: childrenOfRow,
    spacing: 0.045 * widthOfScreen,
    runSpacing: 6,
  );
}
