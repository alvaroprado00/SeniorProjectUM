import 'package:cyber/globals.dart';
import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/model/question.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/components.dart';
import 'new_multiple_choice_page_options.dart';

class MultipleChoiceDescriptionPage extends StatelessWidget {
  const MultipleChoiceDescriptionPage({Key? key}) : super(key: key);
  static final String routeName = '/multipleChoiceDescription';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
          body: SafeArea(child: DescriptionForm())),
    );
  }
}

class DescriptionForm extends StatefulWidget {
  const DescriptionForm({Key? key}) : super(key: key);

  @override
  State<DescriptionForm> createState() => _DescriptionFormState();
}

class _DescriptionFormState extends State<DescriptionForm> {
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
            description: _controllerDescription.text.trim(),
            typeOfQuestion: TypeOfQuestion.multipleChoice,
            longFeedback: '',
            options: [],
            rightOption: 1);

        //Some fields are initialized to random variables
        Navigator.pushNamed(context, MultipleChoiceOptionsPage.routeName,
            arguments: newQuestion);
      }
    };

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.22 * heightOfScreen),
          Text(
            'Question',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.025 * heightOfScreen,
                left: 0.03 * widthOfScreen,
                right: 0.03 * widthOfScreen),
            child: TextFormField(
              inputFormatters: [
                new LengthLimitingTextInputFormatter(210),
              ],
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
      )),
    );
  }
}
