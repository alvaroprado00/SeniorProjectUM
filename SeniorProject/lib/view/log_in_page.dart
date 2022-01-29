import 'package:cyber/view/k_colors.dart';
import 'package:cyber/view/k_components.dart';
import 'package:flutter/material.dart';
import 'k_styles.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  // In order not to leak memory I read that is better to use stateful widgets when using a form with text fields

  late TextEditingController _controllerUser;
  late TextEditingController _controllerPassword;
  final _formKey = GlobalKey<FormState>();

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerUser = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerUser.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logoNoText.png',
                      width: 57,
                      height: 63.63,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('Cyber', style: headingStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('Learn to be safe.',
                          style: subheadingStyleYellow),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 111, 16, 0),
                      child: TextFormField(
                        validator: validatorForEmptyTextField,
                        decoration: getInputDecoration(
                            hintText: 'username',
                            icon: Icon(
                              Icons.person,
                              color: secondaryColor,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: TextFormField(
                        validator: validatorForEmptyTextField,
                        decoration: getInputDecoration(
                            hintText: 'password',
                            icon: Icon(
                              Icons.lock,
                              color: secondaryColor,
                            )),
                      ),
                    ),
                    SizedBox(
                        height: 54,
                        width: 358,
                        child: ElevatedButton(
                          onPressed: () => print('popo'),
                          child: Text('Log In', style: normalText),
                          style: largeYellowButtonStyle,
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(22, 150, 0, 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Don\'t have an account yet?',
                          style: smallTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 54,
                        width: 358,
                        child: ElevatedButton(
                          onPressed: () => print('popo'),
                          child: Text('Sign Up', style: normalText),
                          style: largeGreyButtonStyle,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
