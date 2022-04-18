import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/view/admin/new-course/new_question_feedback_page.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../util/components.dart';

class FillInTheBlanksOptionsPage extends StatelessWidget {
  const FillInTheBlanksOptionsPage({Key? key}) : super(key: key);
  static final String routeName = '/fillInBlanksOptions';

  @override
  Widget build(BuildContext context) {
    //First of all I take the question from the arguments

    final newQuestion =
        ModalRoute.of(context)!.settings.arguments as FillInTheBlanksQuestion;

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
          body: SafeArea(child: OptionsForm(question: newQuestion))),
    );
  }
}

class OptionsForm extends StatefulWidget {
  const OptionsForm({required FillInTheBlanksQuestion this.question});

  final FillInTheBlanksQuestion question;
  @override
  State<OptionsForm> createState() => _OptionsFormState();
}

class _OptionsFormState extends State<OptionsForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerOption;
  int _optionNumber = 1;
  int _blankNumber = 1;

  @override
  void initState() {
    super.initState();
    _controllerOption = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerOption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Define the snackbar
    SnackBar getSnackBar({required String message}) {
      return SnackBar(
        content: Text(
          message,
          style: getNormalTextStyleBlue(),
        ),
        backgroundColor: secondaryColor,
      );
    }

    ;

    //Here I define the function to execute
    void Function() addOption = () {

      int totalNumberOfOptions=6-widget.question.text.split('X').length + 1;

      if (_formKey.currentState!.validate() && _optionNumber<=totalNumberOfOptions) {

        //You will be able to add an option if
        //number of options is less than 6-numberOfSolutions

        widget.question.options.add(_controllerOption.text.trim());

        //Update counter
        setState(() {
          _optionNumber++;
          _controllerOption.clear();
        });
      }

      if(_optionNumber>totalNumberOfOptions+1){
        SnackBar snBar =
        getSnackBar(message: 'Exceeded number of options');
        ScaffoldMessenger.of(context).showSnackBar(snBar);
      }
    };

    void Function() addSolution = () {
      if (_formKey.currentState!.validate()) {
        if (widget.question.text.split('X').length - 1 >= _blankNumber) {
          widget.question.solution[_blankNumber] = _controllerOption.text.trim();

          //Also add the solution as option
          widget.question.options.add(_controllerOption.text);

          //After adding solution increment counter
          setState(() {
            _blankNumber++;
            _controllerOption.clear();
          });
        } else {
          SnackBar snBar =
              getSnackBar(message: 'You exceeded the number of blanks');
          ScaffoldMessenger.of(context).showSnackBar(snBar);
        }
      }
    };

    void Function() navigate = () {
      //Before navigating to the long feedback page I have to verify
      //That the number of solutions is equal to the number of blanks
      //in the text

      if (widget.question.text.split('X').length - 1 == (_blankNumber - 1)) {
        Navigator.pushNamed(context, QuestionLongFeedbackPage.routeName,
            arguments: widget.question);
      } else {
        SnackBar snBar =
            getSnackBar(message: 'No matching between blanks and solutions');
        ScaffoldMessenger.of(context).showSnackBar(snBar);
      }
    };
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.25 * heightOfScreen),
            Text(
              'Enter Option.',
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
                controller: _controllerOption,
                decoration: getInputDecoration(
                    hintText: 'Option ${_optionNumber+_blankNumber-1}',
                    icon: Icon(
                      Icons.view_list,
                      color: secondaryColor,
                    )),
              ),
            ),
            SizedBox(height: 0.29 * heightOfScreen),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              SizedBox(
                  height: getHeightOfSmallButton(),
                  width: getWidthOfSmallButton(),
                  child: ElevatedButton(
                    onPressed: addOption,
                    child: Text('Add as Option ${_optionNumber}',
                        style: getNormalTextStyleBlue()),
                    style: greyButtonStyle,
                  )),
              SizedBox(
                  height: getHeightOfSmallButton(),
                  width: getWidthOfSmallButton(),
                  child: ElevatedButton(
                    onPressed: addSolution,
                    child: Text('Add as Answer ${_blankNumber}',
                        style: getNormalTextStyleBlue()),
                    style: yellowButtonStyle,
                  )),
            ]),
            SizedBox(height: 0.04 * heightOfScreen),
            getNextButton(todo: navigate, large: true),
            SizedBox(height: 0.04 * heightOfScreen),
            getCirclesProgressBar(position: 2, numberOfCircles: 3),
            SizedBox(height: 0.01 * heightOfScreen),
          ],
        ),
      ),
    );
  }
}
