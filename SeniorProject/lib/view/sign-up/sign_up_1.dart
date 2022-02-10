/*

 */

import 'package:cyber/view/sign-up/sign_up_2.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';
import '../useful/components.dart';



class SignUpEmail extends StatefulWidget {
  const SignUpEmail({Key? key}) : super(key: key);

  static final String routeName='/signUpEmail';

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerEmail;

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
                  padding: EdgeInsets.only(top:0.27*heightOfScreen, bottom:0.05*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                  child: Text('Enter your email.', style: getSubheadingStyleWhite()),
                ),

              Padding(
                padding: EdgeInsets.only(bottom:0.35*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                child: TextFormField(
                  validator: validatorForEmptyTextField,
                  controller: _controllerEmail,
                  decoration: getInputDecoration(
                      hintText: 'email',
                      icon: Icon(
                        Icons.email,
                        color: secondaryColor,
                      )),
                ),
              ),

              SizedBox(
                  height: getHeightOfLargeButton(),
                  width: getWidthOfLargeButton(),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPassword.routeName, arguments: _controllerEmail.text,);
                    },
                    child: Text('Next', style: getNormalTextStyleBlue()),
                    style: greyButtonStyle,
                  )),

              Padding(
                padding: EdgeInsets.only(top: 0.03*heightOfScreen),
                child: getCirclesProgressBar(position:1, numberOfCircles: 5, ),
              ),
              ],
            )
            ,
          ),

        ),
      ),
    );
  }
}
