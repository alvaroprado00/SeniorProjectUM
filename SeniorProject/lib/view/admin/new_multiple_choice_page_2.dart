import 'package:cyber/view/admin/long_feedback_page.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart';

import 'new_course_page_2.dart';

class MultipleChoiceOptions extends StatefulWidget {
  const MultipleChoiceOptions({Key? key}) : super(key: key);

  static final String routeName = '/multipleChoiceOptions';

  @override
  State<MultipleChoiceOptions> createState() => _MultipleChoiceOptionsState();
}

class _MultipleChoiceOptionsState extends State<MultipleChoiceOptions> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerOption1;
  late TextEditingController _controllerOption2;
  late TextEditingController _controllerOption3;
  late TextEditingController _controllerOption4;
  late TextEditingController _controllerRightOption;

  @override
  void initState() {
    super.initState();
    _controllerOption1 = TextEditingController();
    _controllerOption2 = TextEditingController();
    _controllerOption3 = TextEditingController();
    _controllerOption4 = TextEditingController();
    _controllerRightOption = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerOption1.dispose();
    _controllerOption2.dispose();
    _controllerOption3.dispose();
    _controllerOption4.dispose();
    _controllerRightOption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 0.05 * heightOfScreen),
                getTextFormFieldForOption(
                    numberOfOption: 1, te: _controllerOption1),
                SizedBox(height: 0.1 * heightOfScreen),
                getTextFormFieldForOption(
                    numberOfOption: 2, te: _controllerOption2),
                SizedBox(height: 0.1 * heightOfScreen),
                getTextFormFieldForOption(
                    numberOfOption: 3, te: _controllerOption3),
                SizedBox(height: 0.1 * heightOfScreen),
                getTextFormFieldForOption(
                    numberOfOption: 4, te: _controllerOption4),
                SizedBox(height: 0.1 * heightOfScreen),
                Text(
                  'Enter correct option.',
                  style: getNormalTextStyleWhite(),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.025 * heightOfScreen,
                      left: 0.35 * widthOfScreen,
                      right: 0.35 * widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    keyboardType: TextInputType.number,
                    controller: _controllerRightOption,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[1-4]')),
                    ],
                    decoration: getInputDecoration(
                        hintText: 'OK',
                        icon: Icon(
                          Icons.check_outlined,
                          color: secondaryColor,
                        )),
                  ),
                ),
                SizedBox(height: 0.1 * heightOfScreen),
                getNextButton(
                    todo: () {
                      Navigator.pushNamed(
                          context, LongFeedbackPage.routeName);
                    },
                    large: true),
                SizedBox(height: 0.04 * heightOfScreen),
                getCirclesProgressBar(position: 2, numberOfCircles: 3),
                SizedBox(height: 0.04 * heightOfScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget getTextFormFieldForOption(
    {required int numberOfOption, required TextEditingController te}) {
  return Column(children: [
    Text(
      'Option $numberOfOption.',
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
        controller: te,
        decoration: inputDecorationForLongText,
        maxLines: 2,
      ),
    ),
  ]);
}
