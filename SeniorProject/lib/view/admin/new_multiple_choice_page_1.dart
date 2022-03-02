import 'package:cyber/globals.dart';
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/model/question.dart';
import 'package:cyber/view/admin/new_multiple_choice_page_2.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart';

class MultipleChoiceDescription extends StatefulWidget {
  const MultipleChoiceDescription({Key? key}) : super(key: key);

  static final String routeName = '/multipleChoiceDescription';

  @override
  State<MultipleChoiceDescription> createState() =>
      _MultipleChoiceDescriptionState();
}

class _MultipleChoiceDescriptionState extends State<MultipleChoiceDescription> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerDescription;

  @override
  void initState() {
    super.initState();
    _controllerDescription = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //I define the function to do when clicking the button

    void Function() setQuestionDescription = () async {
      //I validate the form

      if (_formKey.currentState!.validate()) {
        //I create a Multiple Choice Question
        Question newQuestion = MultipleChoiceQuestion(
            number: newQuestionNum!,
            description: _controllerDescription.text,
            typeOfQuestion: TypeOfQuestion.multipleChoice,
            longFeedback: '',
            options: [],
            rightOption: 1);

        //Some fields are initialized to random variables
        Navigator.pushNamed(context, MultipleChoiceOptions.routeName,
            arguments: newQuestion);
      }
    };

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: getBackButton(context: context),
        title: Text('Multiple Choice'),
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
                  'Enter the question.',
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
                    controller: _controllerDescription,
                    decoration: inputDecorationForLongText,
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 0.29 * heightOfScreen),
                getNextButton(todo: setQuestionDescription, large: true),
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
