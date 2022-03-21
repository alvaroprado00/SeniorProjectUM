import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/admin/new_course_page_1.dart';
import 'package:cyber/view/admin/new_fill_blanks_page_1.dart';
import 'package:cyber/view/admin/new_multiple_choice_page_1.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

class NewQuestionPage extends StatelessWidget {
  const NewQuestionPage({Key? key}) : super(key: key);
  static final String routeName = '/newQuestion';

  @override
  Widget build(BuildContext context) {
    //Function to be executed when submitting a course

    void Function() addCourse = () {
      if (newCourse!.questions.length < 5) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Error',
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
                  Text('You need to add at least 5 questions to the course',
                      style: getNormalTextStyleBlue(),
                      textAlign: TextAlign.center),
                ],
              ),
            );
          },
        );
      } else {
        final CourseController courseController = CourseController();

        //Before uploading the course we have to set the number of questions

        newCourse!.numberOfQuestions = newCourse!.questions.length;

        //After adding the course we show a message of success
        courseController.addCourseToFirebase().then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              value,
              style: getNormalTextStyleBlue(),
            ),
            backgroundColor: secondaryColor,
          ));

          //After that I navigate
          Navigator.pushNamed(context, NewCoursePage.routeName);
        });


      }
    };

    return Scaffold(
      appBar: AppBar(
        leading: getExitButtonAdmin(context: context),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.22 * heightOfScreen,
              width: widthOfScreen,
            ),
            Text(
              'Choose a question to add.',
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
                        context, MultipleChoiceDescription.routeName);
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
                    Navigator.pushNamed(context, FillInBlanksText.routeName);
                  },
                  child: Text('Fill In the blanks',
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
