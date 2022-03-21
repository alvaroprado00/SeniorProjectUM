import 'package:cyber/view/admin/new-course/new_course_page.dart';
import 'package:cyber/view/admin/recommended/new_recommended_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';


class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);
  static final routeName='/adminDashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('Admin Page', style:getSubheadingStyleWhite(),),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: getBackButton(context: context),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: getWidthOfLargeButton(),
                height: getHeightOfSmallButton(),
                child: ElevatedButton(
                  style: greyButtonStyle,
                  onPressed: () {  Navigator.pushNamed(context, NewRecommendedCoursePage.routeName);},
                  child: Text('Recommended', style: getNormalTextStyleBlue(),),
                ),
              ),
              SizedBox(height: 0.13*heightOfScreen,),
              SizedBox(
                width: getWidthOfLargeButton(),
                height: getHeightOfSmallButton(),

                child: ElevatedButton(
                  style: greyButtonStyle,
                  onPressed: () { Navigator.pushNamed(context, NewCoursePage.routeName); },
                  child: Text('Add Course', style: getNormalTextStyleBlue(),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
