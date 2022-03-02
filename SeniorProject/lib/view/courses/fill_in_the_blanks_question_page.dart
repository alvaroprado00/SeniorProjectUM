import 'package:cyber/globals.dart' as globals;
import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/view/courses/question_feedback.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Global variables to be filled when user interacts with buttons
int blankCounter=1;
int numberOfOptions=0;
Map<int, String> proposedSolution={};

class FillInTheBlanksQuestionPage extends StatelessWidget {

  const FillInTheBlanksQuestionPage({Key? key}) : super(key: key);
  static String routeName = '/FillInTheBlanksQuestionPage';

  @override
  Widget build(BuildContext context) {
    final question =
    ModalRoute.of(context)!.settings.arguments as FillInTheBlanksQuestion;

    numberOfOptions=question.solution.length;

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Number of question + options menu
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
                          categoryTitle: stringFromCategory[globals.activeCourse!.category]?? 'No category found',
                          question: question.number,
                          numberOfQuestions: globals.activeCourse!.numberOfQuestions)
                    ],
                  ),

                  //Progress Indicator

                  Container(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(
                        color: secondaryColor,
                        value: (question.number.toDouble()/globals.activeCourse!.numberOfQuestions.toDouble()),
                      )),
                  SizedBox(
                    height: 0.08 * heightOfScreen,
                  ),

                  Text(
                    'Fill In The Blanks.',
                    style: getNormalTextStyleBlueItalicBold(),
                  ),
                  SizedBox(
                    height: 0.03 * heightOfScreen,
                  ),

                  //Here comes the text of the question

                  FillInTheBlanksContent(text: question.text,),

                  SizedBox(height: 0.07*heightOfScreen,),

                  //Options offered to the user

                  getOptions(options: question.options),

                  //Button to submit the info
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.23 * heightOfScreen),
                    child: SizedBox(
                        height: getHeightOfLargeButton(),
                        width: getWidthOfLargeButton(),
                        child: ElevatedButton(
                          onPressed: () {
                              int numberOfMatches=0;
                              bool isRight=false;
                              for(int i=1; i<=question.solution.length; i++){
                                if(question.solution[i]==proposedSolution[i]){
                                  numberOfMatches++;
                                }
                              }

                              if(numberOfMatches==question.solution.length){
                                isRight=true;
                              }

                              //I update the global variables once answer submitted
                              globals.userProgress!.add(isRight);
                              globals.activeQuestionNum=globals.activeQuestionNum!+1;

                              // Before navigating to the next page we have to
                              // reset all the variables that we have used so far

                              blankCounter=1;
                              proposedSolution={};

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return QuestionFeedback(args: FeedbackArguments(isRight, question.longFeedback, question.getSolutionAsString()));
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

Widget getOptions({required List<String> options}){

  List<Widget> children=[];

  for(String option in options ){

    children.add(ButtonForOption(option:option));

  }

  return SizedBox(
    height: 0.28*heightOfScreen,

    child:Wrap(children: children, spacing: 0.1*widthOfScreen,runSpacing: 0.05*heightOfScreen,),
  );
}

class ButtonForOption extends StatefulWidget {
  const ButtonForOption({required String this.option});

  final String option;

  @override
  _ButtonForOptionState createState() => _ButtonForOptionState();
}

class _ButtonForOptionState extends State<ButtonForOption> {

  bool _isSelected = false;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightOfScreen*0.07,
      width: widthOfScreen*0.3,
      child: ElevatedButton(
        onPressed: (){
          setState(() {
            if(_isSelected){

              //If the button was already and the user unselects it then we need to reduce the counter
              blankCounter--;

              //We need to delete the last entry on the map
              proposedSolution.remove(blankCounter);
              _isSelected=!_isSelected;

            }else{

              //User selects option then we add it to the map and increment counter
              //just if the counter is < numberOfOptions
              if(blankCounter<=numberOfOptions){
                proposedSolution[blankCounter]=widget.option;
                blankCounter++;
                _isSelected=!_isSelected;
              }
            }


          });
        },
        style: _isSelected? yellowButtonStyle: greyButtonStyle,
        child: _isSelected? Text((blankCounter-1).toString(), style: getNormalTextStyleBlue(),): Text(widget.option, style: getNormalTextStyleBlue(),)
      ),
    );

  }
}



class FillInTheBlanksContent extends StatelessWidget {

  const FillInTheBlanksContent({required String this.text});

  final String text;


  @override
  Widget build(BuildContext context) {

    final List<String> split=text.split('X');

    return RichText(
      //I create the first part of the text up to the first blank space
      text: TextSpan(
          text: split[0],
          style: getNormalTextStyleBlue(),
          //Now for each blank space I return a blank space and the following text up to the next blank
          children:getRestOfText(splittedText:split.sublist(1)),
       )
    );
  }
}


class BlankSpace extends StatelessWidget {

  const BlankSpace({required int this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.2*widthOfScreen,
      height: 0.027*heightOfScreen,
      child: (Text(number.toString(), style: getNormalTextStyleBlue(), textAlign: TextAlign.center,)),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
        ),
      ),
    );
  }
}


List<InlineSpan> getRestOfText({required List<String> splittedText}){

  var children=<InlineSpan>[];
  var i=1;
  for (String s in splittedText){
    children.add(WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: BlankSpace(number: i,),
       ),  );
    children.add(TextSpan(text: s, style:getNormalTextStyleBlue()));
    i++;
  }

  return children;
}


