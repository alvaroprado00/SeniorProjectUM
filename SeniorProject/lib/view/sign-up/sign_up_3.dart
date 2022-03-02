import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/sign-up/profile_created.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';

import 'package:flutter/material.dart';

import '../main.dart';


class SignUpUsername extends StatefulWidget {
  const SignUpUsername({Key? key}) : super(key: key);
  static final routeName= '/SignUpUsername';

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

  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
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
                        context: context)),

                Padding(
                  padding: EdgeInsets.only(top:0.2*heightOfScreen, bottom:0.025*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                  child: Text('Enter a username.', style: getSubheadingStyleWhite()),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom:0.025*heightOfScreen, left: 0.05*widthOfScreen, right: 0.05*widthOfScreen),
                  //This is a widget that helps us to have a text with different styles
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:getSmallTextStyle(),
                      children: [
                        TextSpan(text: 'We will use your username to get your initial avatar from '),
                        TextSpan(text: 'ROBOHASH', style: smallTextStyleYellow),
                      ]
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(bottom:0.37*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
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

                SizedBox(
                    height: getHeightOfLargeButton(),
                    width: getWidthOfLargeButton(),
                    child: ElevatedButton(
                      onPressed: () async {
                        UserCustom userCreated=UserCustom(args[0],_controllerUsername.text);

                        //Before going to the next page we create the user

                        await UserController.addUserToAuthAndFirestore(u: userCreated, password: args[1]).then((value) {


                          //I make the screen hold for 2s before using navigator so the user is able to read the message
                          Future.delayed(Duration(seconds: 2));

                          if(value is UserCustom){
                            Navigator.pushNamed(context, ProfileCreated.routeName, arguments: value);
                          }else{
                            SnackBar snBar= SnackBar(content: Text(value, style: getNormalTextStyleBlue(),), backgroundColor: secondaryColor,);
                            ScaffoldMessenger.of(context).showSnackBar(snBar);
                            Navigator.pushNamed(context, HomePage.routeName);
                          }
                        });

                      },
                      child: Text('Next', style:  getNormalTextStyleBlue()),
                      style: greyButtonStyle,
                    )),

                Padding(
                  padding: EdgeInsets.only(top: 0.03*heightOfScreen),
                  child: getCirclesProgressBar(position:3, numberOfCircles: 5,),
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
