import 'package:cyber/view/sign-up/sign_up_3.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

import '../useful/components.dart';


class SignUpPassword extends StatefulWidget {
  const SignUpPassword({Key? key}) : super(key: key);

  static final routeName= '/SignUpPassword';

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerPassword;


  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerPassword = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: getBackButton(
                        context: context, )),
                Padding(
                  padding: EdgeInsets.only(top:0.27*heightOfScreen, bottom:0.05*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                  child:
                      Text('Enter your password.', style: getSubheadingStyleWhite()),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:0.35*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                  child: TextFormFieldForPassword(_controllerPassword),
                ),

                SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpUsername.routeName, arguments: [email,_controllerPassword.text]);
                      },
                      child: Text('Next', style:  getNormalTextStyleBlue()),
                      style: largeGreyButtonStyle,
                    )),

                Padding(
                  padding: EdgeInsets.only(top: 0.03*heightOfScreen),
                  child: getCirclesProgressBar(position: 2, numberOfCircles: 5, widthOfScreen: widthOfScreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
