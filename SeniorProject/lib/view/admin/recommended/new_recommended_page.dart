import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../util/components.dart';
import '../../util/k_colors.dart';
import '../../util/k_styles.dart';

class NewRecommendedCoursePage extends StatelessWidget {
  const NewRecommendedCoursePage({Key? key}) : super(key: key);

  static final routeName = '/updateRecommended';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: getBackButton(context: context),
        title: Text(
          'Recommended',
          style: getSubheadingStyleWhite(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: NewRecommendedCourseForm(),
        ),
      ),
    );
  }
}

class NewRecommendedCourseForm extends StatefulWidget {
  const NewRecommendedCourseForm({Key? key}) : super(key: key);

  @override
  _NewRecommendedCourseFormState createState() =>
      _NewRecommendedCourseFormState();
}

class _NewRecommendedCourseFormState extends State<NewRecommendedCourseForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerCourseID;
  final CourseController cc = CourseController();

  @override
  void initState() {
    super.initState();
    _controllerCourseID = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerCourseID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function() updateRecommendedCourse = () {
      if (_formKey.currentState!.validate()) {
        cc
            .updateRecommendedCourse(courseID: _controllerCourseID.text)
            .then((val) {
          SnackBar snackBar = SnackBar(
            content: Text(
              val,
              style: getNormalTextStyleWhite(),
            ),
            backgroundColor: secondaryColor,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _controllerCourseID.clear();
        });
      }
    };

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
            left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.27 * heightOfScreen,
            ),
            Text('Enter the ID of the course.',
                style: getNormalTextStyleWhite()),
            SizedBox(
              height: 0.05 * heightOfScreen,
            ),
            TextFormField(
              validator: validatorForEmptyTextField,
              controller: _controllerCourseID,
              decoration: getInputDecoration(
                  hintText: 'course ID',
                  icon: Icon(
                    Icons.numbers,
                    color: secondaryColor,
                  )),
            ),
            SizedBox(
              height: 0.35 * heightOfScreen,
            ),
            SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: updateRecommendedCourse,
                  child: Text('Update', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
          ],
        ),
      ),
    );
  }
}
