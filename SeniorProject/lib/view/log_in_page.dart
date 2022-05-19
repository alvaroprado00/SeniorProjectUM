import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/main.dart';
import 'package:cyber/view/sign-up/email_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  static final routeName = '/LogInPage';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // In order not to leak memory I read that is better to use stateful widgets when using a form with text fields

  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPassword;
  final _formKey = GlobalKey<FormState>();

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Here I define the function to execute when pressing the buttons

    void Function() goToSignUp = () {
      Navigator.pushNamed(context, SignUpEmailPage.routeName);
    };

    void Function() login = () {
      if (_formKey.currentState!.validate()) {
        //We get both the email and password and try to login

        String email =
            _controllerEmail.text.trim(); //I use trim to delete blank spaces
        String password = _controllerPassword.text;

        UserController.loginWithEmailAndPassword(
                email: email, password: password)
            .then((value) {
          if (value is UserCredential) {
            //If the user logs In then we again navigate to the home Page since it would have been notified
            //of the changes and now will display the dashboard
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomePage.routeName, (Route<dynamic> route) => false);
          } else {
            SnackBar snBar = SnackBar(
              content: Text(
                value,
                style: getNormalTextStyleBlue(),
              ),
              backgroundColor: secondaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snBar);
          }
        });
      }
    };

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 0.05 * heightOfScreen,
                  ),
                  Image.asset(
                    'assets/images/logoNoText.png',
                    width: 0.2 * widthOfScreen,
                    height: 0.08 * heightOfScreen,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.025 * heightOfScreen,
                        bottom: 0.01 * heightOfScreen),
                    child: Text('Cyber', style: getHeadingStyleWhite()),
                  ),
                  Text('Learn to be safe.', style: getSubheadingStyleYellow()),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.1 * heightOfScreen,
                        bottom: 0.015 * heightOfScreen,
                        left: 0.03 * widthOfScreen,
                        right: 0.03 * widthOfScreen),
                    child: TextFormField(
                      controller: _controllerEmail,
                      validator: validatorForEmptyTextField,
                      decoration: getInputDecoration(
                          hintText: 'Email',
                          icon: Icon(
                            Icons.email,
                            color: secondaryColor,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 0.015 * heightOfScreen,
                        left: 0.03 * widthOfScreen,
                        right: 0.03 * widthOfScreen),
                    child: TextFormFieldForPassword(_controllerPassword),
                  ),
                  SizedBox(
                      height: getHeightOfLargeButton(),
                      width: getWidthOfLargeButton(),
                      child: ElevatedButton(
                        onPressed: login,
                        child: Text('Login', style: getNormalTextStyleBlue()),
                        style: yellowButtonStyle,
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.03 * widthOfScreen,
                        top: 0.2 * heightOfScreen,
                        bottom: 0.03 * widthOfScreen),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Don\'t have an account?',
                        style: getSmallTextStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: getHeightOfLargeButton(),
                      width: getWidthOfLargeButton(),
                      child: ElevatedButton(
                        onPressed: goToSignUp,
                        child: Text('Sign Up', style: getNormalTextStyleBlue()),
                        style: greyButtonStyle,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
