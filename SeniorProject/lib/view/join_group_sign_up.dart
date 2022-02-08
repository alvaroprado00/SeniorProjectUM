import 'package:cyber/view/summary_sign_up.dart';
import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'components.dart';
import 'k_styles.dart';
import 'k_values.dart';

class SignUpJoinGroup extends StatefulWidget {
  const SignUpJoinGroup({Key? key}) : super(key: key);

  static final routeName = '/SignUpJoinGroup';

  @override
  State<SignUpJoinGroup> createState() => _SignUpJoinGroupState();
}

class _SignUpJoinGroupState extends State<SignUpJoinGroup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerGroupCode;

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerGroupCode = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerGroupCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //By doing this you use the color specified in the app colorScheme
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        //This is to solve the problem of the overflow caused by the keyboard
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: getBackButton(
                        context: context)),
                Padding(
                  padding: EdgeInsets.only(
                      top: (0.01 * heightOfScreen), bottom: (0.001 * heightOfScreen)),
                  child: Icon(
                    Icons.groups,
                    color: secondaryColor,
                    size: 0.12 * heightOfScreen,
                  ),
                ),
                Text(
                  'Groups',
                  style: getSubheadingStyleWhite(),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: (0.02 * heightOfScreen),
                        left: widthOfScreen * 0.1,
                        right: widthOfScreen * 0.1),
                    child: Text(
                      'Join a group with your friends to learn together.',
                      style: getSmallTextStyle(),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: (0.05 * heightOfScreen),
                      bottom: (0.03 * heightOfScreen),
                      left: 0.025 * widthOfScreen,
                      right: 0.025 * widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerGroupCode,
                    decoration: getInputDecoration(
                        hintText: 'Group Code',
                        icon: Icon(
                          Icons.lock,
                          color: secondaryColor,
                        )),

                  ),
                ),
                SizedBox(
                    height: 0.07 * heightOfScreen,
                    width: 0.95 * widthOfScreen,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Join', style: getNormalTextStyleBlue()),
                      style: largeYellowButtonStyle,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                      widthOfScreen * 0.18,
                      heightOfScreen * 0.15,
                      widthOfScreen * 0.18,
                      heightOfScreen * 0.03,
                    ),
                    child: Text(
                      'Don\'t have a group yet?',
                      style: getSubheadingStyleWhite(),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: heightOfScreen * 0.06,
                        left: widthOfScreen * 0.07,
                        right: widthOfScreen * 0.07),
                    child: Text(
                      'Don\'t worry you can create one later or create one of your own.',
                      style: getSmallTextStyle(),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                    height: 0.07 * heightOfScreen,
                    width: 0.95 * widthOfScreen,
                    child: ElevatedButton(
                      onPressed: () {Navigator.pushNamed(context, SignUpSummary.routeName);},
                      child: Text('Skip', style: getNormalTextStyleBlue()),
                      style: largeGreyButtonStyle,
                    )),

                Padding(
                  padding: EdgeInsets.only(top: 0.03*heightOfScreen),
                  child: getCirclesProgressBar(position:5, numberOfCircles: 5,widthOfScreen: widthOfScreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
