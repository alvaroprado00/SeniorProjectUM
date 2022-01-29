import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';
import 'k_styles.dart';

class SignUpUsername extends StatefulWidget {
  const SignUpUsername({Key? key}) : super(key: key);

  @override
  State<SignUpUsername> createState() => _SignUpUsernameState();
}

class _SignUpUsernameState extends State<SignUpUsername> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerUsername;

  get smallTextStyleYellow => TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
      fontSize: 16,
      color: secondaryColor);

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerUsername.dispose();
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
                  padding: const EdgeInsets.fromLTRB(0, 184, 0, 0),
                  child: Text('Enter a username.', style: subheadingStyleWhite),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 11, 25, 0),
                  //This is a widget that helps us to have a text with different styles
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:smallTextStyle,
                      children: [
                        TextSpan(text: 'We will use your username to get your initial avatar from '),
                        TextSpan(text: 'ROBOHASH', style: smallTextStyleYellow),
                      ]
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(16,23, 16, 0),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerUsername,
                    decoration: getInputDecoration(
                        hintText: 'username',
                        icon: Icon(
                          Icons.person,
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
                        onPressed: () => print(_controllerUsername.value),
                        child: Text('Next', style: normalText),
                        style: largeGreyButtonStyle,
                      )),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0,16, 0, 35),
                  child: getCirclesProgressBar(position:3, numberOfCircles: 5),
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
