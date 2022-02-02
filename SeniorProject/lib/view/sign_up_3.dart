import 'package:cyber/model/user.dart';
import 'package:cyber/view/profile_created.dart';
import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';
import 'k_styles.dart';

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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding=MediaQuery.of(context).padding;
    height=height-padding.top;


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
                  padding: EdgeInsets.only(top:0.2*height, bottom:0.025*height, left: 0.03*width, right: 0.03*width),
                  child: Text('Enter a username.', style: getSubheadingStyleWhite(widthOfScreen: width)),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom:0.025*height, left: 0.05*width, right: 0.05*width),
                  //This is a widget that helps us to have a text with different styles
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:getSmallTextStyle(widthOfScreen: width),
                      children: [
                        TextSpan(text: 'We will use your username to get your initial avatar from '),
                        TextSpan(text: 'ROBOHASH', style: smallTextStyleYellow),
                      ]
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(bottom:0.37*height, left: 0.03*width, right: 0.03*width),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerUsername,
                    decoration: getInputDecoration(
                        widthOfScreen: width,
                        hintText: 'username',
                        icon: Icon(
                          Icons.person,
                          color: secondaryColor,

                        )),
                  ),
                ),

                SizedBox(
                    height: getHeightOfLargeButton(heightOfScreen: height),
                    width: getWidthOfLargeButton(widthOfScreen: width),
                    child: ElevatedButton(
                      onPressed: () {
                        User userCreated=User(args[0],_controllerUsername.text,args[1],);
                        Navigator.pushNamed(context, ProfileCreated.routeName, arguments: userCreated);
                      },
                      child: Text('Next', style:  getNormalTextStyleBlue(widthOfScreen: width)),
                      style: largeGreyButtonStyle,
                    )),

                Padding(
                  padding: EdgeInsets.only(top: 0.03*height),
                  child: getCirclesProgressBar(position:3, numberOfCircles: 5,widthOfScreen: width),
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
