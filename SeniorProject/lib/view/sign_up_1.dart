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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 218, 0, 0),
                  child: Text('Enter your email.', style: subheadingStyleWhite),
                ),

              Padding(
                padding: EdgeInsets.fromLTRB(16,38, 16, 0),
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

              Padding(
                padding: EdgeInsets.fromLTRB(0,250, 0, 0),
                child: SizedBox(
                    height: 54,
                    width: 358,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPassword.routeName, arguments: _controllerEmail.text);
                      },
                      child: Text('Next', style: normalTextStyle),
                      style: largeGreyButtonStyle,
                    )),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0,16, 0, 35),
                child: getCirclesProgressBar(position:1, numberOfCircles: 5),
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
