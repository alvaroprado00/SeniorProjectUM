import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:flutter/material.dart';

import '../../../controller/course_controller.dart';
import '../../util/k_styles.dart';
import 'new_featured_page.dart';

class UpdateRecommendedCoursePage extends StatelessWidget {
  const UpdateRecommendedCoursePage({Key? key}) : super(key: key);

  static final routeName = '/updateRecommended';

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Recommended',
          style: getSubheadingStyleWhite(),
        ),
        centerTitle: true,
        elevation: 0,
        leading: getBackButton(context: context),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: cc.getRecommendedCourseID(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CategorySelectionCardsAdmin(
              courseID: snapshot.data,
              isFeatured: false,
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
