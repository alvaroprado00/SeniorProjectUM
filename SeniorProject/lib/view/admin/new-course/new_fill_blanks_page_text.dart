import 'package:cyber/globals.dart';
import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../util/components.dart';
import 'new_fill_blanks_page_blanks.dart';

class FillInTheBlanksTextPage extends StatelessWidget {
  const FillInTheBlanksTextPage({Key? key}) : super(key: key);

  static final String routeName = '/fillInBlanksText';

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(child: TextForm()));
  }
}

class TextForm extends StatefulWidget {
  const TextForm({Key? key}) : super(key: key);

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
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

    void Function() addText = () {
      if (_formKey.currentState!.validate()) {
        //Create a new Fill In the blanks Question
        FillInTheBlanksQuestion newQuestion = FillInTheBlanksQuestion(
            longFeedback: '',
            number: newQuestionNum!,
            typeOfQuestion: TypeOfQuestion.fillInTheBlanks,
            text: _controllerText.text,
            solution: {},
            options: []);

        //Navigate to next page
        Navigator.pushNamed(context, FillInTheBlanksOptionsPage.routeName,
            arguments: newQuestion);
      }
    };
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.1 * heightOfScreen),
          Text(
            'Enter the text. Place an X where the blank must appear.',
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
              decoration: inputDecorationForLongText,
              maxLines: 10,
            ),
          ),
          Spacer(),
          getNextButton(todo: addText, large: true),
          SizedBox(height: 0.04 * heightOfScreen),
          getCirclesProgressBar(position: 1, numberOfCircles: 3),
          SizedBox(height: 0.01 * heightOfScreen),
        ],
      ),
    );
  }
}
