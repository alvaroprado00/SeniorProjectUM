import 'package:cyber/model/fill_in_the_blanks_question.dart';
import 'package:cyber/view/admin/long_feedback_page.dart';

import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart';

class FillInBlanksOptions extends StatefulWidget {
  const FillInBlanksOptions({Key? key}) : super(key: key);

  static final String routeName = '/fillInBlanksOptions';

  @override
  State<FillInBlanksOptions> createState() => _FillInBlanksOptionsState();
}

class _FillInBlanksOptionsState extends State<FillInBlanksOptions> {
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
    //First of all I take the question from the arguments

    final newQuestion =
        ModalRoute.of(context)!.settings.arguments as FillInTheBlanksQuestion;

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
      if (_formKey.currentState!.validate()) {
        newQuestion.options.add(_controllerOption.text);

        //Update counter
        setState(() {
          _optionNumber++;
        });
      }
    };

    void Function() addSolution = () {
      if (_formKey.currentState!.validate()) {
        if (newQuestion.text.split('X').length - 1 >= _blankNumber) {
          newQuestion.solution[_blankNumber] = _controllerOption.text;

          //After adding solution increment counter
          setState(() {
            _blankNumber++;
            _optionNumber++;
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

      if (newQuestion.text.split('X').length - 1 == (_blankNumber - 1)) {
        Navigator.pushNamed(context, LongFeedbackPage.routeName,
            arguments: newQuestion);
      } else {
        SnackBar snBar =
            getSnackBar(message: 'No matching between blanks and solutions');
        ScaffoldMessenger.of(context).showSnackBar(snBar);
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
                        hintText: 'Option $_optionNumber',
                        icon: Icon(
                          Icons.view_list,
                          color: secondaryColor,
                        )),
                  ),
                ),
                SizedBox(height: 0.29 * heightOfScreen),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
        ),
      ),
    );
  }
}
