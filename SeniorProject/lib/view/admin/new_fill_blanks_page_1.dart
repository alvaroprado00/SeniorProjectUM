import 'package:cyber/globals.dart';
import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/view/admin/new_fill_blanks_page_2.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart';

class FillInBlanksText extends StatefulWidget {
  const FillInBlanksText({Key? key}) : super(key: key);

  static final String routeName = '/fillInBlanksText';

  @override
  State<FillInBlanksText> createState() => _FillInBlanksTextState();
}

class _FillInBlanksTextState extends State<FillInBlanksText> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerText;

  @override
  void initState() {
    super.initState();
    _controllerText = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //I define the function to execute

    void Function() addText=(){

      if(_formKey.currentState!.validate()){

        //Create a new Fill In the blanks Question
        FillInTheBlanksQuestion newQuestion= FillInTheBlanksQuestion(longFeedback: '', number: newQuestionNum!, typeOfQuestion: TypeOfQuestion.fillInTheBlanks, text: _controllerText.text, solution: {}, options: []);

        //Navigate to next page
        Navigator.pushNamed(context, FillInBlanksOptions.routeName, arguments: newQuestion);
      }
    };
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: getBackButton(context: context),
        title: Text('Fill In The Blanks'),
        centerTitle: true,
        titleTextStyle: getSubheadingStyleWhite(),
        elevation: 0,
        actions: <Widget>[
          getExitButtonAdmin(context: context),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 0.22 * heightOfScreen),
                Text(
                  'Enter the text',
                  style: getNormalTextStyleWhite(),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.025 * heightOfScreen,
                      left: 0.03 * widthOfScreen,
                      right: 0.03 * widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerText,
                    decoration: getInputDecoration(
                        hintText:
                            'Enter the text of the question and place an X where the blank will appear',
                        icon: Icon(
                          Icons.article_outlined,
                          color: secondaryColor,
                        )),
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 0.33 * heightOfScreen),
                getNextButton(
                    todo: addText,
                    large: true),
                SizedBox(height: 0.04 * heightOfScreen),
                getCirclesProgressBar(position: 1, numberOfCircles: 3),
                SizedBox(height: 0.01 * heightOfScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
