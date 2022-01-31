import 'package:cyber/view/sign_up_3.dart';
import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';
import 'k_styles.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({Key? key}) : super(key: key);

  static final routeName= '/SignUpPassword';

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerPassword;
  bool _isObscure = true;




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
    final email = ModalRoute.of(context)!.settings.arguments as String;
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
                  child:
                      Text('Enter your password.', style: subheadingStyleWhite),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 38, 16, 0),
                  child: TextFormField(
                      obscureText: _isObscure,
                      validator: validatorForEmptyTextField,
                      controller: _controllerPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: tertiaryColor,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: tertiaryColor, width: 1.0),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: secondaryColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: secondaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        hintStyle: textFieldStyle,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
                  child: SizedBox(
                      height: 54,
                      width: 358,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpUsername.routeName, arguments: [email,_controllerPassword.text]);
                        },
                        child: Text('Next', style: normalTextStyle),
                        style: largeGreyButtonStyle,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 35),
                  child: getCirclesProgressBar(position: 2, numberOfCircles: 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
