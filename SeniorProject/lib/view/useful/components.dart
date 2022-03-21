import 'package:cyber/view/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import 'functions.dart';
import 'k_colors.dart';
import 'k_styles.dart';
import 'k_values.dart';

/**
 * Class that defines the behaviour of a TextFormField for the password. Since it is used more than once and has
 * stateful behaviour, a different class was created. You need to specify the controller for the text field
 */

class TextFormFieldForPassword extends StatefulWidget {
  const TextFormFieldForPassword(this.controller);

  final TextEditingController controller;

  @override
  _TextFormFieldForPasswordState createState() =>
      _TextFormFieldForPasswordState();
}

class _TextFormFieldForPasswordState extends State<TextFormFieldForPassword> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      validator: validatorForEmptyTextField,
      controller: widget.controller,
      decoration: InputDecoration(
          hintStyle: getTexFieldTextStyle(),
          filled: true,
          fillColor: tertiaryColor,
          hintText: 'password',
          contentPadding: EdgeInsets.only(
              top: 0.08 * widthOfScreen, left: 0.08 * widthOfScreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: tertiaryColor, width: 1.0),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: secondaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: secondaryColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )),
    );
  }
}

/**
 * Function to create a row of dots. The number specified in position will be colored yellow.
 * Used as a progress Indicator in the sign-up flow
 * Uses the function getCircle()
 */
Widget getCirclesProgressBar({
  required int position,
  required int numberOfCircles,
}) {
  final children = <Widget>[];

  for (var i = 1; i <= numberOfCircles; i++) {
    if (position == i) {
      children.add(getCircle(
        color: secondaryColor,
        size: 0.02 * widthOfScreen,
      ));
    } else {
      children.add(getCircle(
        color: quinaryColor,
        size: 0.02 * widthOfScreen,
      ));
    }
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: children,
  );
}

/**
 * Function to create a row of dots. All numbers< positions will be yellow
 * Used as a progress Indicator in the pause menu
 * Uses the function getCircle()
 */
Widget getCirclesProgressBarForPauseMenu(
    {required int position, required int numberOfCircles}) {
  final children = <Widget>[];

  for (var i = 1; i <= numberOfCircles; i++) {
    if (i < position) {
      children
          .add(getCircle(color: secondaryColor, size: 0.04 * widthOfScreen));
    } else {
      children.add(getCircle(color: quinaryColor, size: 0.04 * widthOfScreen));
    }
  }

  return Container(
    height: 0.05 * heightOfScreen,
    width: 0.8 * widthOfScreen,
    alignment: Alignment.center,
    child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );
}

Widget getCirclesProgressBarForCourseProgression(
    {required List<bool> answers, required int numberOfCircles}) {
  final children = <Widget>[];

  for (var i = 0; i < numberOfCircles; i++) {
    if (i < answers.length) {
      children.add(getCircle(
          color: answers[i] ? Colors.green : Colors.red,
          size: 0.04 * widthOfScreen));
    } else {
      children.add(getCircle(color: quinaryColor, size: 0.04 * widthOfScreen));
    }
  }
  return Container(
    height: 0.05 * heightOfScreen,
    width: 0.8 * widthOfScreen,
    alignment: Alignment.center,
    child: ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );
}

Widget getCircle({required Color color, required double size}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
    child: SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

/**
 * Function that returns a back button. You need to specify the context so the
 * function in the onPressed param makes sense.
 */

IconButton getBackButton({required BuildContext context}) {
  return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.chevron_left,
        color: secondaryColor,
        size: 0.06 * heightOfScreen,
      ));
}

/**
 * Function that returns an exit button for the admin pages to return from any
 * of them to the actions page.
 */

IconButton getExitButtonAdmin({required BuildContext context}) {
  return IconButton(
      onPressed: () {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 0.25 * heightOfScreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Are you sure you want to exit?',
                      style: getSubheadingStyleYellow(),
                    ),
                    Text(
                      'Your progress will not be saved',
                      style: getNormalTextStyleBlue(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: getHeightOfSmallButton(),
                          width: getWidthOfSmallButton(),
                          child: ElevatedButton(
                            style: yellowButtonStyle,
                            child: Text(
                              'No',
                              style: getNormalTextStyleBlue(),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          height: getHeightOfSmallButton(),
                          width: getWidthOfSmallButton(),
                          child: ElevatedButton(
                            style: greyButtonStyle,
                            child: Text(
                              'Yes',
                              style: getNormalTextStyleBlue(),
                            ),
                            onPressed: () => print('popo'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      icon: Icon(
        Icons.clear,
        color: secondaryColor,
        size: 0.05 * heightOfScreen,
      ));
}

/**
 * This widget is the optionButton used in the course flow
 * Which allows the user to exit the course saving the progress
 * or exit it whithout saving the progress
 */
Widget getOptionsButton(
    {required BuildContext context,
    required String courseTitle,
    required String categoryTitle,
    required int question,
    required int numberOfQuestions}) {
  return IconButton(
      icon: Icon(
        Icons.menu,
        color: primaryColor,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                    top: 0.1 * widthOfScreen, bottom: 0.1 * widthOfScreen),
                height: 0.4 * heightOfScreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      categoryTitle,
                      style: getNormalTextStyleBlue(),
                    ),
                    Text(
                      courseTitle,
                      style: getSubheadingStyleYellow(),
                    ),
                    getCirclesProgressBarForPauseMenu(
                        position: question, numberOfCircles: numberOfQuestions),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getSaveCurrentCourseButton(context: context),
                        SizedBox(
                          width: 0.06 * widthOfScreen,
                        ),
                        getExitCourseButton(context: context),
                      ],
                    ),
                    getResumeButton(context: context),
                  ],
                ),
              );
            });
      });
}

getExitCourseButton({required BuildContext context}) {
  return SizedBox(
    height: getHeightOfSmallButton(),
    width: getWidthOfSmallButton(),
    child: ElevatedButton(
      style: greyButtonStyle,
      child: Text(
        'Exit',
        style: getNormalTextStyleBlue(),
      ),
      onPressed: () {
        Navigator.pushNamed(context, DashboardPage.routeName);
      },
    ),
  );
}

getSaveCurrentCourseButton({required BuildContext context}) {
  return SizedBox(
    height: getHeightOfSmallButton(),
    width: getWidthOfSmallButton(),
    child: ElevatedButton(
        style: yellowButtonStyle,
        child: Text(
          'Save',
          style: getNormalTextStyleBlue(),
        ),
        onPressed: () async {
          await activeUser!.updateCurrentCourse();
          //Once the user is updated, then we go to the dashboard
          Navigator.pushNamed(context, DashboardPage.routeName);
        }),
  );
}

getResumeButton({required BuildContext context}) {
  return SizedBox(
    height: getHeightOfLargeButton(),
    width: getWidthOfLargeButton(),
    child: ElevatedButton(
      style: blueButtonStyle,
      child: Text(
        'Resume',
        style: getNormalTextStyleWhite(),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

/**
 * Function that returns a grey box with rounded corners containing a child
 * specified in the param. Used in the app to display different types of
 * text
 */
Widget getGreyTextHolderContainer({required Widget child}) {
  return Container(
    padding: EdgeInsets.all(widthOfScreen * 0.02),
    decoration: new BoxDecoration(
        color: quinaryColor,
        borderRadius: new BorderRadius.all(
          Radius.circular(0.05 * widthOfScreen),
        )),
    child: child,
  );
}

/**
 * Function that returns the Next Button. You need to specify
 * the function to execute when pressing it
 */
Widget getNextButton({required void Function() todo, required bool large}) {
  return SizedBox(
      height: large ? getHeightOfLargeButton() : getHeightOfSmallButton(),
      width: large ? getWidthOfLargeButton() : getWidthOfSmallButton(),
      child: ElevatedButton(
        onPressed: todo,
        child: Text('Next', style: getNormalTextStyleBlue()),
        style: greyButtonStyle,
      ));
}

/**
 * Function that returns the Add question Button.
 */

Widget getAddQuestionButton({required void Function() todo}) {
  return SizedBox(
      height: getHeightOfLargeButton(),
      width: getWidthOfLargeButton(),
      child: ElevatedButton(
        onPressed: todo,
        child: Text('Add Question', style: getNormalTextStyleBlue()),
        style: yellowButtonStyle,
      ));
}

/**
 * Method to get a container with the text divided into two lines.
 * You specify the first line in param txt1 and the second one in
 * txt2
 */
getDoubleLineText({required String txt1, required String txt2}) {
  return Container(
    width: 0.27 * widthOfScreen,
    child: Column(
      children: [
        Text(
          txt1,
          style: getNormalTextStyleBlue(),
        ),
        Text(
          txt2,
          style: getNormalTextStyleBlue(),
        ),
      ],
    ),
  );
}
