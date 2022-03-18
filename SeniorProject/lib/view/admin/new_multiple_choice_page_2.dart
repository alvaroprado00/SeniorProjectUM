import 'package:cyber/model/multiple_choice_question.dart';
import 'package:cyber/view/admin/long_feedback_page.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart';

class MultipleChoiceOptions extends StatefulWidget {
  const MultipleChoiceOptions({Key? key}) : super(key: key);

  static final String routeName = '/multipleChoiceOptions';

  @override
  State<MultipleChoiceOptions> createState() => _MultipleChoiceOptionsState();
}

class _MultipleChoiceOptionsState extends State<MultipleChoiceOptions> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerOption;
  late TextEditingController _controllerRightOption;
  int _numberOfOption=1;
  bool _completedOptions=false;


  @override
  void initState() {
    super.initState();
    _controllerOption = TextEditingController();
    _controllerRightOption = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerOption.dispose();
    _controllerRightOption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //I get the question to continue setting other fields
    final newQuestion =
        ModalRoute.of(context)!.settings.arguments as MultipleChoiceQuestion;

    //Function executed when submitting the form
    void Function() addOption = () {
      if (_formKey.currentState!.validate()) {

        //In case the form is adding an option this is executed

        if(_numberOfOption<=4){
          newQuestion.options.add(_controllerOption.text);
          setState(() {
            _numberOfOption++;
            if(_numberOfOption==5){
              _completedOptions=true;
            }
          });
        }else{

          //In case the form is adding the number of the right option
          //because it has already added the 4 options

          //I need to substract one since if the right option is 1 we
          //need to store 0 because is the reference in the list

          newQuestion.rightOption = (int.parse(_controllerRightOption.text)-1);

          _numberOfOption=1;

          //Now we are in the position of navigating to the last page
          Navigator.pushNamed(context, LongFeedbackPage.routeName,
              arguments: newQuestion);
        }
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
                SizedBox(height: 0.25 * heightOfScreen),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _completedOptions? getTextFormFieldForRightOption(te: _controllerRightOption):getTextFormFieldForOption(numberOfOption: _numberOfOption, te: _controllerOption ),

                ),

                SizedBox(height: 0.32 * heightOfScreen),
                getNextButton(todo: addOption, large: true),
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

List<Widget> getTextFormFieldForRightOption({required TextEditingController te}){
 return[
   Text(
     'Enter correct option.',
     style: getNormalTextStyleWhite(),
     textAlign: TextAlign.center,
   ),
   Padding(
     padding: EdgeInsets.only(
         top: 0.025 * heightOfScreen,
         left: 0.35 * widthOfScreen,
         right: 0.35 * widthOfScreen,
     bottom:0.07*heightOfScreen),
     child: TextFormField(
       validator: validatorForRightOption,
       keyboardType: TextInputType.number,
       controller: te,
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
  ];
}

List<Widget> getTextFormFieldForOption(
    {required int numberOfOption, required TextEditingController te}) {
  return[
    Text(
      'Option $numberOfOption/4',
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
  ];
}