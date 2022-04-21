import 'package:cyber/globals.dart' as globals;
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/view/courses/question_feedback.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
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
      int optSelected = 5;
      //With this loop I get what option the user has selected
      for (bool selected in ToggleButtonOptions.isSelectedNew) {
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
      optSelected = 5;
    };

    return Scaffold(
        backgroundColor: tertiaryColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: getOptionsButton(
                            context: context,
                            courseTitle: globals.activeCourse!.title,
                            categoryTitle: categoryToString[
                                    globals.activeCourse!.category] ??
                                'No category found',
                            question: question.number,
                            numberOfQuestions:
                                globals.activeCourse!.numberOfQuestions)),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${question.number} of ${globals.activeCourse?.numberOfQuestions}',
                        style: getNormalTextStyleBlue(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.02 * widthOfScreen, right: 0.02 * widthOfScreen),
                  child: Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: LinearProgressIndicator(
                          color: secondaryColor,
                          value: (question.number.toDouble() /
                              globals.activeCourse!.numberOfQuestions
                                  .toDouble()),
                        )),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: EdgeInsets.all(0.02 * widthOfScreen),
                  child: Text(
                    question.description,
                    style: getNormalTextStyleBlue(),
                    textAlign: TextAlign.start,
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                ToggleButtonOptions(options: question.options),
                Spacer(
                  flex: 1,
                ),
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
          ),
        ));
  }
}

class ToggleButtonOptions extends StatefulWidget {
  ToggleButtonOptions({required List<String> this.options});

  final List<String> options;
  static List<bool> isSelected = [false, false, false, false];
  static List<bool> isSelectedNew = List.generate(4, (index) => false);

  @override
  _ToggleButtonOptionsState createState() => _ToggleButtonOptionsState();
}

class _ToggleButtonOptionsState extends State<ToggleButtonOptions> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      //children: getWidgetsForOptions(widget.options, isSelectedNew),
      children: [
        ButtonForOption(
          text: widget.options[0],
          order: 0,
          isSelectedNew: ToggleButtonOptions.isSelectedNew[0],
        ),
        ButtonForOption(
          text: widget.options[1],
          order: 1,
          isSelectedNew: ToggleButtonOptions.isSelectedNew[1],
        ),
        ButtonForOption(
          text: widget.options[2],
          order: 2,
          isSelectedNew: ToggleButtonOptions.isSelectedNew[2],
        ),
        ButtonForOption(
          text: widget.options[3],
          order: 3,
          isSelectedNew: ToggleButtonOptions.isSelectedNew[3],
        )
      ],
      isSelected: ToggleButtonOptions.isSelectedNew,
      selectedColor: secondaryColor,
      borderRadius: BorderRadius.circular(15),
      fillColor: Colors.transparent,
      splashColor: Colors.transparent,
      renderBorder: false,
      direction: Axis.vertical,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              //buttonIndex < ToggleButtonOptions.isSelected.length;
              buttonIndex < ToggleButtonOptions.isSelectedNew.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              ToggleButtonOptions.isSelectedNew[buttonIndex] =
                  !ToggleButtonOptions.isSelectedNew[buttonIndex];
              //ToggleButtonOptions.isSelected[buttonIndex] = true;
              // optionSelected = buttonIndex;
            } else {
              ToggleButtonOptions.isSelectedNew[buttonIndex] = false;
              // ToggleButtonOptions.isSelected[buttonIndex] = false;
            }
          }
        });
      },
    );
  }
}

List<Widget> getWidgetsForOptions(
    List<String> options, List<bool> isSelectedNew) {
  List<Widget> optionButtons = [];

  int i = 0;
  for (String option in options) {
    optionButtons.add(ButtonForOption(
      text: option,
      order: i,
      isSelectedNew: isSelectedNew[i],
    ));
    i++;
  }
  return optionButtons;
}

class ButtonForOption extends StatefulWidget {
  const ButtonForOption(
      {required String this.text,
      required int this.order,
      bool this.isSelectedNew = false});

  final String text;
  final int order;
  final bool isSelectedNew;

  @override
  State<ButtonForOption> createState() => _ButtonForOptionState();
}

class _ButtonForOptionState extends State<ButtonForOption> {
  bool pressAttention = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 0.94 * widthOfScreen,
        margin: EdgeInsets.only(bottom: 8),
        //height: 0.1*heightOfScreen,
        //color: pressAttention ? Colors.transparent : secondaryColor,
        decoration: BoxDecoration(
            color: widget.isSelectedNew ? secondaryColor : Colors.transparent,
            border: Border.all(color: quinaryColor),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.only(
              top: 0.05 * widthOfScreen,
              bottom: 0.05 * widthOfScreen,
              left: 0.04 * widthOfScreen,
              right: 0.02 * widthOfScreen),
          child: Row(
            children: [
              Text(
                numberToOptionLetter[widget.order] ?? 'X',
                style: getNormalTextStyleBlue(),
              ),
              SizedBox(
                width: 0.05 * widthOfScreen,
              ),
              Expanded(
                  child: Text(
                widget.text,
                style: getNormalTextStyleBlue(),
              )),
            ],
          ),
        ));
  }
}
