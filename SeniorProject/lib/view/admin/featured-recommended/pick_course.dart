/**
 * This Page will be called with a category as argument and
 * a boolean indicating if it comes from the featuredOption
 * or the recommendedOption. Also with the ID that identifies
 * the recommended/featured course to be able to build the radiobuttons
 */
import 'package:flutter/material.dart';

import '../../../controller/course_controller.dart';
import '../../../main.dart';
import '../../util/components.dart';
import '../../util/k_colors.dart';
import '../../util/k_styles.dart';
import '../../util/k_values.dart';

class PickACoursePage extends StatelessWidget {
  const PickACoursePage({Key? key}) : super(key: key);

  static final routeName = '/pickACourse';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PickACourseArgs;

    final CourseController cc = CourseController();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          categoryToString[args.category]!,
          style: getSubheadingStyleWhite(),
        ),
        centerTitle: true,
        elevation: 0,
        leading: getBackButton(context: context),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: cc.getCourseNamesFromCategory(category: args.category),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
                child: Center(
                  child: Text(
                    'There are no courses in ${categoryToString[args.category]}',
                    style: getSubheadingStyleWhite(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return CoursesInCategory(args: args, coursesMap: snapshot.data);
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error getting courses in category: ${categoryToString[args.category]}',
                style: getHeadingStyleWhite(),
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

class CoursesInCategory extends StatefulWidget {
  const CoursesInCategory(
      {Key? key, required this.args, required this.coursesMap})
      : super(key: key);

  final Map<String, String> coursesMap;
  final PickACourseArgs args;

  @override
  State<CoursesInCategory> createState() => _CoursesInCategoryState();
}

class _CoursesInCategoryState extends State<CoursesInCategory> {
  String? _selectedCourseID;
  late CourseController cc;

  @override
  void initState() {
    //When I initialize the widget I set the param _selectedCourseID to the
    //current recommended/featured course which was looked up in the DB

    super.initState();
    _selectedCourseID = widget.args.idOfCourse;
    cc = CourseController();
  }

  @override
  Widget build(BuildContext context) {
    void Function() updateFunction = () async {
      String message = '';
      if (widget.args.idOfCourse != _selectedCourseID) {
        final Future Function({required String courseID}) futureToExecute =
            widget.args.isFeatured
                ? cc.updateFeaturedCourseByID
                : cc.updateRecommendedCourseByID;

        await futureToExecute(courseID: _selectedCourseID!).then((val) {
          message =
              'Update was successful. Course: ${widget.coursesMap[_selectedCourseID]!}';
        }).catchError((error) {
          message = 'Update was unsuccessful.';
        });
      } else {
        message = 'This course is already selected.';
      }

      var snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(
          message,
          style: getNormalTextStyleWhite(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (r) => false);
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 0.05 * heightOfScreen,
        ),
        Text(
          'Choose a course.',
          style: getNormalTextStyleWhite(),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 0.05 * heightOfScreen,
        ),
        SizedBox(
            height: 0.6 * heightOfScreen,
            width: widthOfScreen,
            child: RawScrollbar(
                isAlwaysShown: true,
                radius: Radius.circular(20),
                thickness: 5,
                thumbColor: quinaryColor,
                child: SingleChildScrollView(child: getButtons()))),
        SizedBox(
          height: getHeightOfLargeButton(),
          width: getWidthOfLargeButton(),
          child: ElevatedButton(
            style: greyButtonStyle,
            onPressed: updateFunction,
            child: Text(
              'Update',
              style: getNormalTextStyleBlue(),
            ),
          ),
        )
      ],
    );
  }

  getButtons() {
    List<Widget> children = [];

    widget.coursesMap.forEach((key, value) {
      Widget listTile = ListTile(
        title: Text(
          value,
          style: getSubheadingStyleWhite(),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 0.1 * widthOfScreen),
          child: Radio<String>(
            fillColor:
                MaterialStateColor.resolveWith((states) => secondaryColor),
            value: key,
            groupValue: _selectedCourseID,
            onChanged: (String? value) {
              setState(() {
                _selectedCourseID = value;
              });
            },
          ),
        ),
      );

      children.add(listTile);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

class PickACourseArgs {
  final bool isFeatured;
  final Category category;
  final String idOfCourse;

  const PickACourseArgs(
      {required Category this.category,
      required String this.idOfCourse,
      required bool this.isFeatured});
}
