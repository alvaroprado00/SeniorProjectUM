import 'package:cyber/view/sign-up/summary_sign_up.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

class SignUpGroupPage extends StatelessWidget {
  const SignUpGroupPage({Key? key}) : super(key: key);

  static final routeName = '/SignUpJoinGroup';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          //By doing this you use the color specified in the app colorScheme
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
              //This is to solve the problem of the overflow caused by the keyboard
              child: SingleChildScrollView(child: GroupForm()))),
    );
  }
}

class GroupForm extends StatefulWidget {
  const GroupForm({Key? key}) : super(key: key);

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerGroupCode;

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerGroupCode = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerGroupCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: AlignmentDirectional.centerStart,
                child: getBackButton(context: context)),
            Padding(
              padding: EdgeInsets.only(
                  top: (0.01 * heightOfScreen),
                  bottom: (0.001 * heightOfScreen)),
              child: Icon(
                Icons.groups,
                color: secondaryColor,
                size: 0.12 * heightOfScreen,
              ),
            ),
            Text(
              'Groups',
              style: getSubheadingStyleWhite(),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: (0.02 * heightOfScreen),
                    left: widthOfScreen * 0.1,
                    right: widthOfScreen * 0.1),
                child: Text(
                  'Join a group with your friends to learn together.',
                  style: getSmallTextStyle(),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(
                  top: (0.05 * heightOfScreen),
                  bottom: (0.03 * heightOfScreen),
                  left: 0.025 * widthOfScreen,
                  right: 0.025 * widthOfScreen),
              child: TextFormField(
                validator: validatorForEmptyTextField,
                controller: _controllerGroupCode,
                decoration: getInputDecoration(
                    hintText: 'Group Code',
                    icon: Icon(
                      Icons.lock,
                      color: secondaryColor,
                    )),
              ),
            ),
            SizedBox(
                height: 0.07 * heightOfScreen,
                width: 0.95 * widthOfScreen,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Join', style: getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                  widthOfScreen * 0.1,
                  heightOfScreen * 0.15,
                  widthOfScreen * 0.1,
                  heightOfScreen * 0.03,
                ),
                child: Text(
                  'Don\'t have a group yet?',
                  style: getSubheadingStyleWhite(),
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: widthOfScreen * 0.07,
                    right: widthOfScreen * 0.07,
                    bottom: 0.06 * heightOfScreen),
                child: Text(
                  'Don\'t worry you can join one later or create one of your own.',
                  style: getSmallTextStyle(),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                height: 0.07 * heightOfScreen,
                width: 0.95 * widthOfScreen,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpSummary.routeName);
                  },
                  child: Text('Skip', style: getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
            Padding(
              padding: EdgeInsets.only(top: 0.03 * heightOfScreen),
              child: getCirclesProgressBar(
                position: 5,
                numberOfCircles: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
