/*

 */

import 'package:cyber/view/sign_up_2.dart';
import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';
import 'k_styles.dart';



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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding=MediaQuery.of(context).padding;
    height=height-padding.top;

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
                      context: context, heightOfScreen: height)),

                Padding(
                  padding: EdgeInsets.only(top:0.27*height, bottom:0.05*height, left: 0.03*width, right: 0.03*width),
                  child: Text('Enter your email.', style: getSubheadingStyleWhite(widthOfScreen: width)),
                ),

              Padding(
                padding: EdgeInsets.only(bottom:0.35*height, left: 0.03*width, right: 0.03*width),
                child: TextFormField(
                  validator: validatorForEmptyTextField,
                  controller: _controllerEmail,
                  decoration: getInputDecoration(
                      widthOfScreen: width,
                      hintText: 'email',
                      icon: Icon(
                        Icons.email,
                        color: secondaryColor,
                      )),
                ),
              ),

              SizedBox(
                  height: getHeightOfLargeButton(heightOfScreen: height),
                  width: getWidthOfLargeButton(widthOfScreen: width),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPassword.routeName, arguments: _controllerEmail.text,);
                    },
                    child: Text('Next', style: getNormalTextStyleBlue(widthOfScreen: width)),
                    style: largeGreyButtonStyle,
                  )),

              Padding(
                padding: EdgeInsets.only(top: 0.03*height),
                child: getCirclesProgressBar(position:1, numberOfCircles: 5, widthOfScreen: width),
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
