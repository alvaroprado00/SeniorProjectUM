import 'package:cyber/view/sign-up/password_page.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../util/components.dart';

class SignUpEmailPage extends StatelessWidget {
  const SignUpEmailPage({Key? key}) : super(key: key);
  static final routeName = '/signUpEmail';

  @override
  Widget build(BuildContext context) {
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
          child: EmailForm(),
        ),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
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
    //I define the function to be executed when the button is pressed
    void Function() goToNextSignUpPage = () {
      if (_formKey.currentState!.validate()) {
        Navigator.pushNamed(
          context,
          PasswordForm.routeName,
          arguments: _controllerEmail.text.trim(),
        );
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
                  Text('Enter your email.', style: getSubheadingStyleWhite()),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
              child: TextFormField(
                validator: validatorForEmail,
                controller: _controllerEmail,
                decoration: getInputDecoration(
                    hintText: 'Email',
                    icon: Icon(
                      Icons.email,
                      color: secondaryColor,
                    )),
              ),
            ),
            Spacer(),
            SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: goToNextSignUpPage,
                  child: Text('Next', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
            Padding(
              padding: EdgeInsets.only(top: 0.03 * heightOfScreen),
              child: getCirclesProgressBar(
                position: 1,
                numberOfCircles: 5,
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
