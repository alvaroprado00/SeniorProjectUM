import 'package:cyber/view/admin/featured-recommended/pick_course.dart';
import 'package:cyber/view/util/cards.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:flutter/material.dart';

import '../../../controller/course_controller.dart';
import '../../util/k_styles.dart';
import '../../util/k_values.dart';

class UpdateFeaturedCoursePage extends StatelessWidget {
  const UpdateFeaturedCoursePage({Key? key}) : super(key: key);

  static final routeName = '/updateFeatured';

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Featured',
          style: getSubheadingStyleWhite(),
        ),
        centerTitle: true,
        elevation: 0,
        leading: getBackButton(context: context),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: cc.getFeaturedCourseID(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CategorySelectionCardsAdmin(
              courseID: snapshot.data,
              isFeatured: true,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error getting the featured course ID',
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

class CategorySelectionCardsAdmin extends StatelessWidget {
  CategorySelectionCardsAdmin(
      {Key? key, required this.courseID, required this.isFeatured})
      : super(key: key);

  final widthOfCards = 0.45 * widthOfScreen;
  final heightOfCards = 0.28 * heightOfScreen;
  final routeToNavigate = PickACoursePage.routeName;
  final String courseID;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          getCardForCategory(
              context: context,
              category: Category.web,
              widthOfCard: widthOfCards,
              heightOfCard: heightOfCards,
              routeToNavigate: routeToNavigate,
              arguments: PickACourseArgs(
                  category: Category.web,
                  idOfCourse: courseID,
                  isFeatured: isFeatured),
              isTemplate: false),
          getCardForCategory(
              context: context,
              category: Category.info,
              widthOfCard: widthOfCards,
              heightOfCard: heightOfCards,
              routeToNavigate: routeToNavigate,
              arguments: PickACourseArgs(
                  category: Category.info,
                  idOfCourse: courseID,
                  isFeatured: isFeatured),
              isTemplate: false),
          getCardForCategory(
              context: context,
              category: Category.socialMedia,
              widthOfCard: widthOfCards,
              heightOfCard: heightOfCards,
              routeToNavigate: routeToNavigate,
              arguments: PickACourseArgs(
                  category: Category.socialMedia,
                  idOfCourse: courseID,
                  isFeatured: isFeatured),
              isTemplate: false),
          getCardForCategory(
              context: context,
              category: Category.devices,
              widthOfCard: widthOfCards,
              heightOfCard: heightOfCards,
              routeToNavigate: routeToNavigate,
              arguments: PickACourseArgs(
                  category: Category.devices,
                  idOfCourse: courseID,
                  isFeatured: isFeatured),
              isTemplate: false),
        ],
      ),
    );
  }
}
