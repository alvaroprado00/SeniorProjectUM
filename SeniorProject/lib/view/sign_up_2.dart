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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding=MediaQuery.of(context).padding;
    height=height-padding.top;

    final email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
                  child:
                      Text('Enter your password.', style: getSubheadingStyleWhite(widthOfScreen: width)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:0.35*height, left: 0.03*width, right: 0.03*width),
                  child: TextFormField(
                      obscureText: _isObscure,
                      validator: validatorForEmptyTextField,
                      controller: _controllerPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: tertiaryColor,
                        hintText: 'Password',
                        contentPadding: EdgeInsets.only(top:0.08*width ,left: 0.08*width),
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
                        hintStyle: getTexFieldTextStyle(widthOfScreen: width)
                      )),
                ),

                SizedBox(
                    height: getHeightOfLargeButton(heightOfScreen: height),
                    width: getWidthOfLargeButton(widthOfScreen: width),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpUsername.routeName, arguments: [email,_controllerPassword.text]);
                      },
                      child: Text('Next', style:  getNormalTextStyleBlue(widthOfScreen: width)),
                      style: largeGreyButtonStyle,
                    )),

                Padding(
                  padding: EdgeInsets.only(top: 0.03*height),
                  child: getCirclesProgressBar(position: 2, numberOfCircles: 5, widthOfScreen: width),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
