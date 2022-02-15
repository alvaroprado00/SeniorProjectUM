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
                        int i=1;
                        int optSelected=1;
                        //With this loop I get what option the user has selected
                       for(bool selected in ToggleButtonOptions.isSelected){
                         if(selected){
                           optSelected=i;
                         }
                         i++;
                       }
                        bool isRight=false;
                       if(optSelected==question.rightOption){
                        isRight=true;
                       }
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return QuestionFeedback(args: FeedbackArguments(isRight, question.longFeedback, question.shortFeedback));
                            });
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

  const QuestionFeedback({required this.args});

  final FeedbackArguments args;

  @override
  State<QuestionFeedback> createState() => _QuestionFeedbackState();
}

class _QuestionFeedbackState extends State<QuestionFeedback> {

  // First we set the learnMore to false to show the content for short feedback
  bool learnMore=false;
  String messageInButton='More';

  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      content: learnMore? getLearnMoreContent(longFeedBack: widget.args.longFeedback): getFeedback(isRight: widget.args.isRight, shortFeeback: widget.args.shortFeedback),
      insetPadding: EdgeInsets.all(10),
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
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Explained', style: getSubheadingStyleBlue(),),
      Divider(indent: 0.01*widthOfScreen, endIndent: 0.01*widthOfScreen, color: primaryColor,thickness: 0.002*widthOfScreen, ),
      SizedBox(height: 0.2*heightOfScreen,child: SingleChildScrollView(child: Text(longFeedBack,style: getNormalTextStyleBlue(),))),
    ],
  );

}
Widget getFeedback({required bool isRight, required String shortFeeback}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
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
            width: widthOfScreen * 0.05,
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
            Icons.clear_rounded,
            color: Colors.red,
          ),
          SizedBox(
            width: widthOfScreen * 0.05,
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
      Divider(indent: 0.01*widthOfScreen, endIndent: 0.01*widthOfScreen, color: primaryColor,thickness: 0.002*widthOfScreen, ),
      getCirclesProgressBarForCourseProgression(answers: [true, true, false], numberOfCircles: activeCourse!.numberOfQuestions),
      SizedBox(height: 0.05*heightOfScreen,),
      Text(shortFeeback, style: getNormalTextStyleBlue(),),

    ],
  );
}

class FeedbackArguments {
  final bool isRight;
  final String longFeedback;
  final String shortFeedback;

  FeedbackArguments(this.isRight, this.longFeedback, this.shortFeedback);
}
