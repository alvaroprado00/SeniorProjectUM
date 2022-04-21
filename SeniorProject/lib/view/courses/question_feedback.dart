import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../globals.dart' as globals;

class QuestionFeedback extends StatefulWidget {
  const QuestionFeedback({required this.args});

  final FeedbackArguments args;

  @override
  State<QuestionFeedback> createState() => _QuestionFeedbackState();
}

class _QuestionFeedbackState extends State<QuestionFeedback> {
  // First we set the learnMore to false to show the content for short feedback
  bool learnMore = false;
  String messageInButton = 'More';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.only(top: 2, bottom: 20, left: 20),
      contentPadding: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: learnMore
          ? getLearnMoreContent(longFeedBack: widget.args.longFeedback)
          : getFeedback(
              isRight: widget.args.isRight,
              shortFeeback: widget.args.shortFeedback),
      insetPadding: EdgeInsets.all(10),
      actions: <Widget>[
        SizedBox(
            height: getHeightOfSmallButton(),
            width: getWidthOfSmallButton(),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  learnMore = !learnMore;
                  if (learnMore) {
                    messageInButton = 'Back';
                  } else {
                    messageInButton = 'More';
                  }
                });
              },
              child: Text(messageInButton, style: getNormalTextStyleBlue()),
              style: greyButtonStyle,
            )),
        SizedBox(
            height: getHeightOfSmallButton(),
            width: getWidthOfSmallButton(),
            child: ElevatedButton(
              onPressed: () {
                nextQuestion(context);
              },
              child: Text('Next', style: getNormalTextStyleWhite()),
              style: blueButtonStyle,
            )),
      ],
    );
  }
}

class FeedbackArguments {
  final bool isRight;
  final String longFeedback;
  final String shortFeedback;

  FeedbackArguments(this.isRight, this.longFeedback, this.shortFeedback);
}

Widget getLearnMoreContent({required String longFeedBack}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Explained',
        style: getSubheadingStyleBlue(),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Divider(
          color: quinaryColor,
          thickness: 1,
        ),
      ),
      SizedBox(
          height: 0.2 * heightOfScreen,
          child: SingleChildScrollView(
              child: Text(
            longFeedBack,
            style: getNormalTextStyleBlue(),
          ))),
    ],
  );
}

Widget getFeedback({required bool isRight, required String shortFeeback}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: isRight
            ? [
                // Icon(
                //   Icons.check_rounded,
                //   color: Colors.green,
                // ),
                // SizedBox(
                //   width: widthOfScreen * 0.05,
                // ),
                Text(
                  'Correct',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )
              ]
            : [
                // Icon(
                //   Icons.clear_rounded,
                //   color: Colors.red,
                // ),
                // SizedBox(
                //   width: widthOfScreen * 0.05,
                // ),
                Text(
                  'Incorrect',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              ],
      ),
      Divider(
        color: quinaryColor,
        thickness: 1,
      ),
      getCirclesProgressBarForCourseProgression(
          answers: globals.userProgress,
          numberOfCircles: globals.activeCourse!.numberOfQuestions),
      SizedBox(
        height: 0.01 * heightOfScreen,
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'ANSWER',
          style: getNormalTextStyleYellowBold(),
        ),
      ),
      Text(
        shortFeeback,
        style: getNormalTextStyleBlue(),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
