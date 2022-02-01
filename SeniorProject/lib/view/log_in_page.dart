import 'package:cyber/view/k_colors.dart';
import 'package:cyber/view/k_components.dart';
import 'package:cyber/view/sign_up_1.dart';
import 'package:flutter/cupertino.dart';
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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding=MediaQuery.of(context).padding;
    //I update the height by subtracting the status bar height

    height=height-padding.top;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logoNoText.png',
                    width: 0.2*width,
                    height: 0.08*height,
                  ),
                  Padding(
                    padding:EdgeInsets.only(top:0.025*height, bottom:0.025*height),
                    child: Text('Cyber', style: headingStyle),
                  ),

                  Text('Learn to be safe.',
                      style: subheadingStyleYellow),
                  Padding(
                    padding: EdgeInsets.only(top:0.1*height, bottom:0.015*height, left: 0.03*width, right: 0.03*width),
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
                    padding: EdgeInsets.only(bottom:0.015*height, left: 0.03*width, right: 0.03*width),
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
                      height: getHeightOfLargeButton(heightOfScreen: height),
                      width: getWidthOfLargeButton(widthOfScreen: width),
                      child: ElevatedButton(
                        onPressed: () => print('popo'),
                        child: Text('Log In', style: normalTextStyle),
                        style: largeYellowButtonStyle,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.03*width,0.24*height, 0.05*height,0.03*width),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Don\'t have an account yet?',
                        style: smallTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: getHeightOfLargeButton(heightOfScreen: height),
                      width: getWidthOfLargeButton(widthOfScreen: width),
                      child: ElevatedButton(
                        onPressed: () {Navigator.pushNamed(context, SignUpEmail.routeName);},
                        child: Text('Sign Up', style: normalTextStyle),
                        style: largeGreyButtonStyle,
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
