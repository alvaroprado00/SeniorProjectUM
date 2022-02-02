import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';
import 'k_styles.dart';

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
    //This is how I get all the dimensions of the screen.
    //The height needs to be updated since we need to subtract the top padding of the status bar

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    height = height - padding.top;

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
                        context: context, heightOfScreen: height)),
                Padding(
                  padding: EdgeInsets.only(
                      top: (0.01 * height), bottom: (0.001 * height)),
                  child: Icon(
                    Icons.groups,
                    color: secondaryColor,
                    size: 0.12 * height,
                  ),
                ),
                Text(
                  'Groups',
                  style: getSubheadingStyleWhite(widthOfScreen: width),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: (0.02 * height),
                        left: width * 0.1,
                        right: width * 0.1),
                    child: Text(
                      'Join a group with your friends to learn together.',
                      style: getSmallTextStyle(widthOfScreen: width),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: (0.05 * height),
                      bottom: (0.03 * height),
                      left: 0.025 * width,
                      right: 0.025 * width),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerGroupCode,
                    decoration: getInputDecoration(
                      widthOfScreen: width,
                        hintText: 'Group Code',
                        icon: Icon(
                          Icons.lock,
                          color: secondaryColor,
                        )),

                  ),
                ),
                SizedBox(
                    height: 0.07 * height,
                    width: 0.95 * width,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Join', style: getNormalTextStyleBlue(widthOfScreen: width)),
                      style: largeYellowButtonStyle,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.18,
                      height * 0.15,
                      width * 0.18,
                      height * 0.03,
                    ),
                    child: Text(
                      'Don\'t have a group yet?',
                      style: getSubheadingStyleWhite(widthOfScreen: width),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: height * 0.05,
                        left: width * 0.07,
                        right: width * 0.07),
                    child: Text(
                      'Don\'t worry you can create one later or create one of your own.',
                      style: getSmallTextStyle(widthOfScreen: width),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                    height: 0.07 * height,
                    width: 0.95 * width,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Skip', style: getNormalTextStyleBlue(widthOfScreen: width)),
                      style: largeGreyButtonStyle,
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.02, bottom: 0.03 * height),
                  child: getCirclesProgressBar(position: 5, numberOfCircles: 5, widthOfScreen: width),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
