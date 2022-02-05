import 'package:cyber/view/k_colors.dart';
import 'package:cyber/view/k_components.dart';
import 'package:cyber/view/sign_up_1.dart';
import 'package:flutter/material.dart';
import 'k_styles.dart';
import 'k_values.dart';

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

    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;

    var padding=MediaQuery.of(context).padding;
    //I update the height by subtracting the status bar height

    heightOfScreen=heightOfScreen-padding.top;

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
                    width: 0.2*widthOfScreen,
                    height: 0.08*heightOfScreen,
                  ),
                  Padding(
                    padding:EdgeInsets.only(top:0.025*heightOfScreen, bottom:0.01*heightOfScreen),
                    child: Text('Cyber', style: getHeadingStyleWhite()),
                  ),

                  Text('Learn to be safe.',
                      style: getSubheadingStyleYellow()),
                  Padding(
                    padding: EdgeInsets.only(top:0.1*heightOfScreen, bottom:0.015*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                    child: TextFormField(
                      validator: validatorForEmptyTextField,
                      decoration: getInputDecoration(
                          widthOfScreen: widthOfScreen,
                          hintText: 'username',
                          icon: Icon(
                            Icons.person,
                            color: secondaryColor,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom:0.015*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                    child: TextFormField(
                      validator: validatorForEmptyTextField,
                      decoration: getInputDecoration(
                          widthOfScreen: widthOfScreen,
                          hintText: 'password',
                          icon: Icon(
                            Icons.lock,
                            color: secondaryColor,
                          )),
                    ),
                  ),

                  SizedBox(
                      height: getHeightOfLargeButton(),
                      width: getWidthOfLargeButton(),
                      child: ElevatedButton(
                        onPressed: () => print('popo'),
                        child: Text('Login', style: getNormalTextStyleBlue()),
                        style: largeYellowButtonStyle,
                      )),

                  Padding(
                    padding: EdgeInsets.only(left:0.03*widthOfScreen,top:0.28*heightOfScreen,bottom: 0.03*widthOfScreen),
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
                        onPressed: () {Navigator.pushNamed(context, SignUpEmail.routeName);},
                        child: Text('Sign Up', style: getNormalTextStyleBlue()),
                        style: largeGreyButtonStyle,
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
