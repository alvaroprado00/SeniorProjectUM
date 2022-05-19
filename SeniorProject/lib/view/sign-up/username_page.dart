import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/model/level.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/sign-up/profile_created.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class SignUpUsernamePage extends StatelessWidget {
  const SignUpUsernamePage({Key? key}) : super(key: key);
  static final routeName = '/SignUpUsername';

  @override
  Widget build(BuildContext context) {
    //Here I get the email and the password as a List of String
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          leading: getBackButton(context: context),
        ),
        body: SafeArea(
            child: UsernameForm(
          args: args,
        )));
  }
}

class UsernameForm extends StatefulWidget {
  const UsernameForm({required List<String> this.args});

  final List<String> args;

  @override
  State<UsernameForm> createState() => _UsernameFormState();
}

class _UsernameFormState extends State<UsernameForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerUsername;
  late bool _buttonWorking;

  get smallTextStyleYellow => TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
      fontSize: 16,
      color: secondaryColor);

  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
    _buttonWorking = true;
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Here I define the function to execute when the button is pressed
    void Function() signUpUser = () async {
      if (_formKey.currentState!.validate() && _buttonWorking) {
        //Disable the button to avoid another click
        _buttonWorking = false;

        //Once validated the form we create the user

        UserCustom userCreated = UserCustom(
            email: widget.args[0],
            username: _controllerUsername.text.trim(),
            level: Level(totalXP: 0, levelNumber: 1, xpEarnedInLevel: 0),
            profilePictureActive: _controllerUsername.text.trim(),
            userGroups: [],
            collectedAvatars: [_controllerUsername.text.trim()],
            collectedBadges: [],
            coursesSaved: [],
            completedCourses: [],
            currentCourse: null,
            isAdmin: false);

        //We have to persist the info

        await UserController.addUserToAuthAndFirestore(
                u: userCreated, password: widget.args[1])
            .then((value) {
          String message = 'Error when adding user to Firestore DB';

          //value will be bool if The user is added to the Auth DB
          if (value is bool) {
            if (value) {
              Navigator.pushNamed(context, ProfileCreated.routeName,
                  arguments: userCreated);
            }
          } else {
            //In case value returned by the Future is a String, it means
            //it couldnt be added to the Auth DB
            message = value;

            SnackBar snBar = SnackBar(
              content: Text(
                message,
                style: getNormalTextStyleBlue(),
              ),
              backgroundColor: secondaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snBar);
            Navigator.pushNamed(
              context,
              HomePage.routeName,
            );
          }
        });
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
                bottom: 0.025 * heightOfScreen,
                left: 0.03 * widthOfScreen,
                right: 0.03 * widthOfScreen),
            child: Text('Enter a username.', style: getSubheadingStyleWhite()),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: 0.025 * heightOfScreen,
                  left: 0.05 * widthOfScreen,
                  right: 0.05 * widthOfScreen),
              //This is a widget that helps us to have a text with different styles
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(style: getSmallTextStyle(), children: [
                  TextSpan(
                      text:
                          'We will use your username to get your initial avatar from '),
                  TextSpan(text: 'ROBOHASH', style: smallTextStyleYellow),
                ]),
              )),
          Padding(
            padding: EdgeInsets.only(
                left: 0.03 * widthOfScreen, right: 0.03 * widthOfScreen),
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
          Spacer(),
          SizedBox(
              height: getHeightOfLargeButton(),
              width: getWidthOfLargeButton(),
              child: ElevatedButton(
                onPressed: signUpUser,
                child: Text('Next', style: getNormalTextStyleBlue()),
                style: greyButtonStyle,
              )),
          Padding(
            padding: EdgeInsets.only(top: 0.03 * heightOfScreen),
            child: getCirclesProgressBar(
              position: 3,
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
