import 'package:cyber/globals.dart';
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
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

    return Scaffold(
      backgroundColor: tertiaryColor,
      body: SafeArea(
          child: SingleChildScrollView(
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
                    '${question.number} of ${activeCourse?.numberOfQuestions}',
                    style: getNormalTextStyleBlue(),
                  ),
                  SizedBox(
                    width: widthOfScreen * 0.25,
                  ),
                  getOptionsButton(
                      context: context,
                      courseTitle: activeCourse!.title,
                      categoryTitle: stringFromCategory[activeCourse!.category]?? 'No category found',
                      question: question.number,
                      numberOfQuestions: activeCourse!.numberOfQuestions)
                ],
              ),
              Container(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(
                    color: secondaryColor,
                    value: 0.1,
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
                height: 0.03 * heightOfScreen,
              ),
              Text(
                'Choose the correct answer.',
                style: getNormalTextStyleBlueItalicBold(),
              ),
              SizedBox(
                height: 0.03 * heightOfScreen,
              ),
              ToggleButtonOptions(options: question.options),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.07 * heightOfScreen, bottom: 0.05 * heightOfScreen),
                child: SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: () {
                        print('popo');
                      },
                      child: Text('Submit', style: getNormalTextStyleWhite()),
                      style: blueButtonStyle,
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class ToggleButtonOptions extends StatefulWidget {
  ToggleButtonOptions({required List<String> this.options});

  final List<String> options;
  final List<bool> isSelected = [true, false, false, false];

  @override
  _ToggleButtonOptionsState createState() => _ToggleButtonOptionsState();
}

class _ToggleButtonOptionsState extends State<ToggleButtonOptions> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: getWidgetsForOptions(widget.options),
      isSelected: widget.isSelected,
      borderRadius: BorderRadius.circular(0.05 * widthOfScreen),
      fillColor: secondaryColor,
      renderBorder: false,
      direction: Axis.vertical,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < widget.isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              widget.isSelected[buttonIndex] = true;
              optionSelected = buttonIndex;
            } else {
              widget.isSelected[buttonIndex] = false;
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
                matchingMap[order] ?? 'X',
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

class QuestionFeedback extends StatefulWidget {

  const QuestionFeedback({required bool this.isRight, required String this.shortFeedback, required String this.longFeedback});

  final bool isRight;
  final String longFeedback;
  final String shortFeedback;

  @override
  State<QuestionFeedback> createState() => _QuestionFeedbackState();
}

class _QuestionFeedbackState extends State<QuestionFeedback> {
  bool learnMore=false;
  String messageInButton='More';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: learnMore? getLearnMoreContent(longFeedBack: widget.longFeedback): getFeedback(isRight: widget.isRight),
      actions: <Widget>[
        SizedBox(
            height: getHeightOfSmallButton(),
            width: getWidthOfSmallButton(),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  learnMore=!learnMore;
                  if(learnMore){
                    messageInButton='Back';
                  }else{
                    messageInButton='More';
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
                print('popo');
              },
              child: Text('Next', style: getNormalTextStyleWhite()),
              style: blueButtonStyle,
            )),
      ],
    );
  }


}

Widget getLearnMoreContent({required String longFeedBack}){

  return Column(
    children: [
      Text('Explained', style: getSubheadingStyleBlue(),),
      Divider(indent: 0.1*widthOfScreen,endIndent: 0.1*widthOfScreen,),
      SingleChildScrollView(child: Text(longFeedBack,style: getNormalTextStyleBlue(),)),
    ],
  );

}
Widget getFeedback({required bool isRight}){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: isRight
            ? [
          Icon(
            Icons.check_rounded,
            color: Colors.green,
          ),
          SizedBox(
            width: widthOfScreen * 0.1,
          ),
          Text(
            'Right',
            style: TextStyle(
                fontSize: 24,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          )
        ]
            : [
          Icon(
            Icons.border_clear_rounded,
            color: Colors.red,
          ),
          SizedBox(
            width: widthOfScreen * 0.1,
          ),
          Text(
            'Wrong',
            style: TextStyle(
                fontSize: 24,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          )
        ],
      ),
      Divider(indent: 0, endIndent: 0, color: secondaryColor,),
      getCirclesProgressBarForCourseProgression(answers: [true, true, false], numberOfCircles: activeCourse!.numberOfQuestions),

    ],
  );
}