import 'package:cyber/globals.dart';
import 'package:cyber/model/question.dart';
import 'package:cyber/view/admin/new-course/new_question_page.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../util/components.dart';

class QuestionLongFeedbackPage extends StatelessWidget {
  const QuestionLongFeedbackPage({Key? key}) : super(key: key);
  static final String routeName = '/longFeedbackPage';

  @override
  Widget build(BuildContext context) {
    //I get the question
    //Now we don't know exactly which type of question it is

    final newQuestion = ModalRoute.of(context)!.settings.arguments as Question;

    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: getBackButton(context: context),
            title: Text(stringFromTypeOfQuestion[newQuestion.typeOfQuestion]!),
            centerTitle: true,
            titleTextStyle: getSubheadingStyleWhite(),
            elevation: 0,
            actions: <Widget>[
              getExitButtonAdmin(context: context),
            ],
          ),
          body: SafeArea(
              child: FeedbackForm(
            question: newQuestion,
          ))),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({required Question this.question});

  final Question question;

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerFeedback;

  @override
  void initState() {
    super.initState();
    _controllerFeedback = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerFeedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SnackBar snBar = SnackBar(
      content: Text(
        'Added Question $newQuestionNum',
        style: getNormalTextStyleBlue(),
      ),
      backgroundColor: secondaryColor,
    );

    void Function() addQuestionToCourse = () {
      if (_formKey.currentState!.validate()) {
        widget.question.longFeedback = _controllerFeedback.text;

        //I have the question completely built so I add it to the new-course
        //Also I need to update the question number

        newCourse!.questions.add(widget.question);
        newQuestionNum = newQuestionNum! + 1;

        //I show a message of success
        ScaffoldMessenger.of(context).showSnackBar(snBar);

        //I wait before navigating
        Future.delayed(Duration(seconds: 3));

        Navigator.pushNamed(
          context,
          NewQuestionPage.routeName,
        );
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
              'Enter long feedback.',
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
                controller: _controllerFeedback,
                decoration: inputDecorationForLongText,
                maxLines: 5,
              ),
            ),
            SizedBox(height: 0.33 * heightOfScreen),
            getAddQuestionButton(todo: addQuestionToCourse),
            SizedBox(height: 0.04 * heightOfScreen),
            getCirclesProgressBar(position: 3, numberOfCircles: 3),
            SizedBox(height: 0.01 * heightOfScreen),
          ],
        ),
      ),
    );
  }
}
