import 'package:cyber/globals.dart';
import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/components.dart';
import '../../util/k_colors.dart';
import 'new_fill_blanks_page_blanks.dart';

class FillInTheBlanksTextPage extends StatelessWidget {
  const FillInTheBlanksTextPage({Key? key}) : super(key: key);

  static final String routeName = '/fillInBlanksText';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
          body: SafeArea(child: TextForm())),
    );
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

        //I get the text
        String text=_controllerText.text.trim();

        //Then I get the number of blanks
        int numberOfBlanks=text.split('X').length - 1;

        if(numberOfBlanks>3){
          SnackBar snBar=SnackBar(
            content: Text(
              'You exceeded the number of blanks',
              style: getNormalTextStyleBlue(),
            ),
            backgroundColor: secondaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snBar);
          return;
        }

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.22*heightOfScreen,),
            Text(
              'Enter the text. Place an X where the blank must appear. Maximum of 3 Blanks.',
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
                  new LengthLimitingTextInputFormatter(300),
                ],
                validator: validatorForEmptyTextField,
                controller: _controllerText,
                decoration: getInputDecoration(
                    hintText:
                        'Enter text',
                    icon: Icon(
                      Icons.article_outlined,
                      color: secondaryColor,
                    )),
                maxLines: 5,
              ),
            ),
            SizedBox(height: 0.32*heightOfScreen,),
          getNextButton(todo: addText, large: true),
            SizedBox(height: 0.04*heightOfScreen,),
            getCirclesProgressBar(position: 1, numberOfCircles: 3),
            SizedBox(height: 0.01*heightOfScreen,),
        ],),
      ),
    );
  }
}
