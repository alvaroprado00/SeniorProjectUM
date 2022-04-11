import 'dart:collection';

import 'package:cyber/controller/course_controller.dart';
import 'package:flutter/material.dart';

import '../../util/components.dart';
import '../../util/k_colors.dart';
import '../../util/k_styles.dart';
import '../../util/k_values.dart';

class DeleteCoursePage extends StatelessWidget {
  const DeleteCoursePage({Key? key}) : super(key: key);

  static final routeName = '/deleteCourse';

  @override
  Widget build(BuildContext context) {
    CourseController cc = CourseController();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Delete Course',
          style: getSubheadingStyleWhite(),
        ),
        centerTitle: true,
        elevation: 0,
        leading: getBackButton(context: context),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: cc.getCourseNames(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text(
                  'No courses found',
                  style: getHeadingStyleWhite(),
                ),
              );
            } else {
              return CourseList(courses: snapshot.data);
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error getting the course names',
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

class CourseList extends StatefulWidget {
  CourseList({Key? key, required Map<String, String> this.courses})
      : super(key: key);

  Map<String, String> courses;
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  String? _selectedCourseID;
  late CourseController cc;

  @override
  void initState() {
    //When I initialize the widget I set the param _selectedCourseID to the
    //current recommended/featured course which was looked up in the DB

    super.initState();

    cc = CourseController();
  }

  @override
  Widget build(BuildContext context) {
    void Function() deleteFunction = () async {
      String message = '';

      await cc
          .deleteCourseByTitle(widget.courses[_selectedCourseID!]!)
          .then((value) {
        message = 'Deleted course with ID: ${value}';
      }).catchError((onError) {
        message = 'Error deleting course';
      });

      var snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(
          message,
          style: getNormalTextStyleWhite(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        //I have to remove the course that has been deleted and call setState
        //to force a rebuild
        widget.courses.remove(_selectedCourseID!);
      });
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 0.05 * heightOfScreen,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Text(
            'Choose the course to be deleted. This action cannot be undone.',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 0.05 * heightOfScreen,
        ),
        SizedBox(
            height: 0.5 * heightOfScreen,
            width: widthOfScreen,
            child: RawScrollbar(
                isAlwaysShown: true,
                radius: Radius.circular(20),
                thickness: 5,
                thumbColor: quinaryColor,
                child: SingleChildScrollView(child: getButtons()))),
        SizedBox(
          height: 0.08 * heightOfScreen,
        ),
        SizedBox(
          height: getHeightOfLargeButton(),
          width: getWidthOfLargeButton(),
          child: ElevatedButton(
            style: greyButtonStyle,
            onPressed: deleteFunction,
            child: Text(
              'Delete',
              style: getNormalTextStyleBlue(),
            ),
          ),
        )
      ],
    );
  }

  getButtons() {
    List<Widget> children = [];

    //I order the courses alphabetically
    Map<String, String> orderedCourses = new SplayTreeMap<String, String>.from(
        widget.courses,
        (key1, key2) => widget.courses[key1]!.compareTo(widget.courses[key2]!));

    orderedCourses.forEach((key, value) {
      Widget listTile = ListTile(
        title: Text(
          value,
          style: getSubheadingStyleWhite(),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 0.18 * widthOfScreen),
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
