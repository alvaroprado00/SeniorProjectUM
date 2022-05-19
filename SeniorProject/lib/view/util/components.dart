import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../config/fixed_values.dart';
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
      validator: validatorForPassword,
      controller: widget.controller,
      decoration: InputDecoration(
          hintStyle: getTexFieldTextStyle(),
          filled: true,
          fillColor: tertiaryColor,
          hintText: 'Password',
          contentPadding: EdgeInsets.only(
              top: 0.08 * widthOfScreen, left: 0.08 * widthOfScreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
      splashRadius: 25,
      splashColor: quaternaryColor,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        CupertinoIcons.back,
        color: secondaryColor,
        size: 36,
      ));
}

/**
 * Function that returns an exit button for the admin pages to return from any
 * of them to the actions page.
 */

IconButton getExitButtonAdmin({required BuildContext context}) {
  return IconButton(
      splashRadius: 25,
      splashColor: quaternaryColor,
      onPressed: () {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 0.3 * heightOfScreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10),
                      child: Text(
                        'Are you sure you want to exit?',
                        style: getSubheadingStyleYellow(),
                      ),
                    ),
                    Text(
                      'Your progress will not be saved.',
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
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomePage.routeName,
                                  (Route<dynamic> route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            });
      },
      icon: Icon(
        CupertinoIcons.clear,
        color: secondaryColor,
        size: 28,
      ));
}

/**
 * This widget is the optionButton used in the new-course flow
 * Which allows the user to exit the new-course saving the progress
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
      padding: EdgeInsets.only(top: 0),
      splashRadius: 20.0,
      splashColor: secondaryColor,
      onPressed: () {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                    top: 0.05 * widthOfScreen, bottom: 0.1 * widthOfScreen),
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
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (r) => false);
      },
    ),
  );
}

getSaveCurrentCourseButton({required BuildContext context}) {
  //We get an instance of our activeUserController

  ActiveUserController activeUserController = Get.find<ActiveUserController>();
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
          await activeUserController.updateCurrentCourse().then((value) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (r) => false);
          });
          //Once the user is updated, then we go to the dashboard
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

// Divider and subtitle with padding

class SubtitleDivider extends StatelessWidget {
  const SubtitleDivider({Key? key, required this.subtitle}) : super(key: key);

  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widthOfScreen * 0.03,
                heightOfScreen * 0.02,
                widthOfScreen * 0.04,
                heightOfScreen * 0.005),
            child: Text(
              this.subtitle,
              style: getNormalTextStyleBlue(),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(
                widthOfScreen * 0.01,
                heightOfScreen * 0.00,
                widthOfScreen * 0.01,
                heightOfScreen * 0.01),
            child: Divider(
              thickness: 1,
              color: quinaryColor,
            )),
      ],
    );
  }
}

class SubtitleDividerAdmin extends StatelessWidget {
  const SubtitleDividerAdmin({Key? key, required this.subtitle})
      : super(key: key);

  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widthOfScreen * 0.03,
                heightOfScreen * 0.02,
                widthOfScreen * 0.04,
                heightOfScreen * 0.005),
            child: Text(
              this.subtitle,
              style: getNormalTextStyleWhite(),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(
                widthOfScreen * 0.01,
                heightOfScreen * 0.00,
                widthOfScreen * 0.01,
                heightOfScreen * 0.01),
            child: Divider(
              thickness: 1,
              color: quinaryColor,
            )),
      ],
    );
  }
}

/**
 * This class when built displays a grey container with three subcontainers
 * separated by vertical dividers. Is both used in the profile and in the
 * category place. To create one you have to specify the strings you want
 * diplayed in each subcontainer
 */
class ProgressContainerThreeFields extends StatelessWidget {
  const ProgressContainerThreeFields(
      {required String this.field1,
      required String this.field2,
      required String this.field3});

  final String field1;
  final String field2;
  final String field3;

  @override
  Widget build(BuildContext context) {
    final List<String> field1List = field1.split(' ');
    final List<String> field2List = field2.split(' ');
    final List<String> field3List = field3.split(' ');

    return getGreyTextHolderContainer(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      getDoubleLineText(txt1: field1List[0], txt2: field1List[1]),
      SizedBox(
          height: 0.07 * heightOfScreen,
          child: VerticalDivider(
            color: secondaryColor,
            thickness: 2,
          )),
      getDoubleLineText(txt1: field2List[0], txt2: field2List[1]),
      SizedBox(
          height: 0.07 * heightOfScreen,
          child: VerticalDivider(
            color: secondaryColor,
            thickness: 2,
          )),
      getDoubleLineText(txt1: field3List[0], txt2: field3List[1])
    ]));
  }
}

/**
 * Function to get a container with a badge from
 * the name of the badge stored in the user
 */
getContainerForBadge({required String nameOfIcon, required double size}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: primaryColor,
    ),
    child: Icon(
      FontAwesomeIconsMap[nameOfIcon],
      color: secondaryColor,
      size: 0.3 * size,
    ),
  );
}
