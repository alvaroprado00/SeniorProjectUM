import 'package:cyber/view/sign-up/username_page.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../util/components.dart';

class SignUpPasswordPage extends StatelessWidget {
  const SignUpPasswordPage({Key? key}) : super(key: key);

  static final routeName = '/SignUpPassword';

  @override
  Widget build(BuildContext context) {
    //I get the email from the previous page
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: getBackButton(context: context),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
            child: PasswordForm(
          email: email,
        )),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({required String this.email});

  static final routeName = '/SignUpPassword';
  final String email;

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
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
    //Function executed when button pressed
    void Function() goToFinalSignUpPage = () {
      if (_formKey.currentState!.validate()) {
        Navigator.pushNamed(context, SignUpUsernamePage.routeName,
            arguments: [widget.email, _controllerPassword.text]);
      }
    };

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
                bottom: 0.05 * heightOfScreen,
                left: 0.03 * widthOfScreen,
                right: 0.03 * widthOfScreen),
            child:
                Text('Enter your password.', style: getSubheadingStyleWhite()),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
            child: TextFormFieldForPassword(_controllerPassword),
          ),
          Spacer(),
          SizedBox(
              height: getHeightOfLargeButton(),
              width: getWidthOfLargeButton(),
              child: ElevatedButton(
                onPressed: goToFinalSignUpPage,
                child: Text('Next', style: getNormalTextStyleBlue()),
                style: greyButtonStyle,
              )),
          Padding(
            padding: EdgeInsets.only(top: 0.03 * heightOfScreen),
            child: getCirclesProgressBar(
              position: 2,
              numberOfCircles: 5,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
