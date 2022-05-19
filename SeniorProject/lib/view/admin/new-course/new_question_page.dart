import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/admin/dashboard/admin_dashboard.dart';
import 'package:cyber/view/admin/new-course/new_course_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'new_fill_blanks_page_text.dart';
import 'new_multiple_choice_page_description.dart';

class NewQuestionPage extends StatelessWidget {
  const NewQuestionPage({Key? key}) : super(key: key);
  static final String routeName = '/newQuestion';

  @override
  Widget build(BuildContext context) {
    //Function to be executed when submitting a new-course

    void Function() addCourse = () async {
      if (newCourse!.questions.length < 5) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(
                'Questions Required',
                style: getSubheadingStyleBlue(),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.clear_rounded,
                    size: 0.3 * widthOfScreen,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 0.05 * heightOfScreen,
                  ),
                  Text('Add at least 5 questions to add a new course.',
                      style: getNormalTextStyleBlue(),
                      textAlign: TextAlign.center),
                ],
              ),
            );
          },
        );
      } else {
        final CourseController courseController = CourseController();

        String message='';

        //Before uploading the new-course we have to set the number of questions

        newCourse!.numberOfQuestions = newCourse!.questions.length;

        //After adding the new-course we show a message of success
       await courseController
            .addCourseToFirebase(courseToAdd: newCourse!)
            .then((value) {
            message='Course added';
        }).catchError((error){
            message='Course not added';
        });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
          message,
          style: getNormalTextStyleBlue(),
          ),
          backgroundColor: secondaryColor,));

          //After that I navigate
        Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (r) => false);

      }
    };

    return Scaffold(
      appBar: AppBar(
        leading: getBackButton(context: context),
        actions: [getExitButtonAdmin(context: context)],
        title: Text(
          'New Question',
          style: getSubheadingStyleWhite(),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widthOfScreen,
            ),
            Text(
              'Choose a type of question:',
              style: getSubheadingStyleWhite(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 0.1 * heightOfScreen,
            ),
            SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, MultipleChoiceDescriptionPage.routeName);
                  },
                  child:
                      Text('Multiple Choice', style: getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),
            SizedBox(
              height: 0.05 * heightOfScreen,
            ),
            SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, FillInTheBlanksTextPage.routeName);
                  },
                  child: Text('Fill in the Blanks',
                      style: getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),
            SizedBox(
              height: 0.2 * heightOfScreen,
            ),
            SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: addCourse,
                  child: Text('Submit Course', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
          ],
        ),
      ),
    );
  }
}
