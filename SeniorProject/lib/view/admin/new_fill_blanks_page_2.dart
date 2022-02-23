import 'package:cyber/view/admin/long_feedback_page.dart';
import 'package:cyber/view/admin/new_multiple_choice_page_2.dart';
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
  final _optionNumber=0;
  final _blankNumber=0;

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
                        hintText:
                        'Option $_optionNumber',
                        icon: Icon(
                          Icons.view_list,
                          color: secondaryColor,
                        )),
                  ),
                ),
                SizedBox(height: 0.29 * heightOfScreen),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[SizedBox(
                      height: getHeightOfSmallButton(),
                      width: getWidthOfSmallButton(),
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        child: Text('Add as Option ${_optionNumber+1}', style:  getNormalTextStyleBlue()),
                        style: greyButtonStyle,
                      )),
                    SizedBox(
                        height: getHeightOfSmallButton(),
                        width: getWidthOfSmallButton(),
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          child: Text('Add as Answer ${_blankNumber+1}', style:  getNormalTextStyleBlue()),
                          style: yellowButtonStyle,
                        )),

                  ]
                ),
                SizedBox(height: 0.04 * heightOfScreen),
                getNextButton(todo: (){Navigator.pushNamed(context, LongFeedbackPage.routeName);}, large: true),
                SizedBox(height: 0.04 * heightOfScreen),
                getCirclesProgressBar(position: 2, numberOfCircles: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
