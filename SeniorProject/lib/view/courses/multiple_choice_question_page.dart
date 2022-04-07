import 'package:cyber/globals.dart' as globals;
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/view/courses/question_feedback.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

// Global variable to save the optionSelected
int optionSelected = 0;

class MultipleChoiceQuestionPage extends StatelessWidget {
  const MultipleChoiceQuestionPage({Key? key}) : super(key: key);
  static String routeName = '/MultipleChoiceQuestionPage';

  @override
  Widget build(BuildContext context) {
    final question =
        ModalRoute.of(context)!.settings.arguments as MultipleChoiceQuestion;

    //Here I define the function executed when the user presses the button

    void Function() submitMultipleChoiceFunction = () {
      int i = 0;
      int optSelected = 0;
      //With this loop I get what option the user has selected
      for (bool selected in ToggleButtonOptions.isSelected) {
        if (selected) {
          optSelected = i;
        }
        i++;
      }
      bool isRight = false;
      if (optSelected == question.rightOption) {
        isRight = true;
      }

      //I update the global variables once answer submitted
      globals.userProgress.add(isRight);
      globals.activeQuestionNum = globals.activeQuestionNum! + 1;

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return QuestionFeedback(
                args: FeedbackArguments(isRight, question.longFeedback,
                    question.getSolutionAsString()));
          });
    };

    return Scaffold(
      backgroundColor: tertiaryColor,
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: widthOfScreen * 0.4,
                    ),
                    Text(
                      '${question.number} of ${globals.activeCourse?.numberOfQuestions}',
                      style: getNormalTextStyleBlue(),
                    ),
                    SizedBox(
                      width: widthOfScreen * 0.25,
                    ),
                    getOptionsButton(
                        context: context,
                        courseTitle: globals.activeCourse!.title,
                        categoryTitle:
                            categoryToString[globals.activeCourse!.category] ??
                                'No category found',
                        question: question.number,
                        numberOfQuestions:
                            globals.activeCourse!.numberOfQuestions)
                  ],
                ),
                Container(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      color: secondaryColor,
                      value: (question.number.toDouble() /
                          globals.activeCourse!.numberOfQuestions.toDouble()),
                    )),
                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                getGreyTextHolderContainer(
                    child: Padding(
                  padding: EdgeInsets.all(0.02 * widthOfScreen),
                  child: Text(
                    question.description,
                    style: getNormalTextStyleBlue(),
                  ),
                )),
                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
                Text(
                  'Choose the correct answer.',
                  style: getNormalTextStyleBlueItalicBold(),
                ),
                Spacer(),

                ToggleButtonOptions(options: question.options),

                Spacer(flex: 2,),
                SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: submitMultipleChoiceFunction,
                      child: Text('Submit', style: getNormalTextStyleWhite()),
                      style: blueButtonStyle,
                    )),
                SizedBox(
                  height: 0.05 * heightOfScreen,
                ),
              ],
            ),
          )),
    );
  }
}

class ToggleButtonOptions extends StatefulWidget {
  ToggleButtonOptions({required List<String> this.options});

  final List<String> options;
  static List<bool> isSelected = [true, false, false, false];

  @override
  _ToggleButtonOptionsState createState() => _ToggleButtonOptionsState();
}

class _ToggleButtonOptionsState extends State<ToggleButtonOptions> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: getWidgetsForOptions(widget.options),
      isSelected: ToggleButtonOptions.isSelected,
      borderRadius: BorderRadius.circular(0.05 * widthOfScreen),
      fillColor: secondaryColor,
      renderBorder: false,
      direction: Axis.vertical,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < ToggleButtonOptions.isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              ToggleButtonOptions.isSelected[buttonIndex] = true;
              optionSelected = buttonIndex;
            } else {
              ToggleButtonOptions.isSelected[buttonIndex] = false;
            }
          }
        });
      },
    );
  }
}

List<Widget> getWidgetsForOptions(List<String> options) {
  List<Widget> optionButtons = [];

  int i = 0;
  for (String option in options) {
    optionButtons.add(ButtonForOption(text: option, order: i));
    i++;
  }
  return optionButtons;
}

class ButtonForOption extends StatelessWidget {
  const ButtonForOption({required String this.text, required int this.order});

  final String text;
  final int order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 0.94 * widthOfScreen,
        //height: 0.1*heightOfScreen,

        child: Padding(
          padding: EdgeInsets.only(
              top: 0.05 * widthOfScreen,
              bottom: 0.05 * widthOfScreen,
              left: 0.02 * widthOfScreen,
              right: 0.02 * widthOfScreen),
          child: Row(
            children: [
              Text(
                numberToOptionLetter[order] ?? 'X',
                style: getNormalTextStyleBlue(),
              ),
              SizedBox(
                width: 0.1 * widthOfScreen,
              ),
              Expanded(
                  child: Text(
                text,
                style: getNormalTextStyleBlue(),
              )),
            ],
          ),
        ));
  }
}
