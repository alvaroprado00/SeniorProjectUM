import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../avatar.dart';
import 'functions.dart';
import 'k_colors.dart';
import 'k_styles.dart';
import 'k_values.dart';



/**
 * Class that defines the behaviour of a TextFormField for the password. Since it is used more than once and has
 * stateful behaviour, a different class was created. You need to specify the controller for the text field
 */

class TextFormFieldForPassword extends StatefulWidget {
  const TextFormFieldForPassword(this.controller);

  final TextEditingController controller;

  @override
  _TextFormFieldForPasswordState createState() =>
      _TextFormFieldForPasswordState();
}

class _TextFormFieldForPasswordState extends State<TextFormFieldForPassword> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      validator: validatorForEmptyTextField,
      controller: widget.controller,
      decoration: InputDecoration(
          hintStyle: getTexFieldTextStyle(),
          filled: true,
          fillColor: tertiaryColor,
          hintText: 'password',
          contentPadding: EdgeInsets.only(
              top: 0.08 * widthOfScreen, left: 0.08 * widthOfScreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: tertiaryColor, width: 1.0),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: secondaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: secondaryColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )),
    );
  }
}

/**
 * Function to create a row of dots. The number specified in position will be colored yellow.
 * Used as a progress Indicator in the sign-up flow
 * Uses the function getCircle()
 */
Widget getCirclesProgressBar(
    {required int position,
    required int numberOfCircles,}) {
  final children = <Widget>[];

  for (var i = 1; i <= numberOfCircles; i++) {
    if (position == i) {
      children.add(getCircle(color: secondaryColor, size: 0.02 * widthOfScreen,));
    } else {
      children.add(getCircle(color: quinaryColor, size: 0.02 * widthOfScreen,));
    }
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: children,
  );
}

/**
 * Function to create a row of dots. All numbers<= positions will be yellow
 * Used as a progress Indicator in the pause menu
 * Uses the function getCircle()
 */
Widget getCirclesProgressBarForPauseMenu(
    {required int position,
      required int numberOfCircles}) {
  final children = <Widget>[];

  for (var i = 1; i <= numberOfCircles; i++) {
    if (i<=position) {
      children.add(getCircle(color: secondaryColor, size: 0.04*widthOfScreen));
    } else {
      children.add(getCircle(color: quinaryColor, size: 0.04*widthOfScreen));
    }
  }

  return Container(
    height: 0.05*heightOfScreen,
    width: 0.8*widthOfScreen,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );

}

Widget getCirclesProgressBarForCourseProgression(
    {required List<bool> answers,
      required int numberOfCircles}) {

  final children = <Widget>[];

  for (var i = 0; i < numberOfCircles; i++) {
    if (i<answers.length) {
      children.add(getCircle(color: answers[i]? Colors.green: Colors.red, size: 0.04*widthOfScreen));
    } else {
      children.add(getCircle(color: quinaryColor, size: 0.04*widthOfScreen));
    }
  }
  return Container(
    height: 0.05*heightOfScreen,
    width: 0.8*widthOfScreen,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );
}



Widget getCircle({required Color color, required double size}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
    child: SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

/**
 * Function that returns a back button. You need to specify the context so the
 * function in the onPressed param makes sense.
 */

IconButton getBackButton({required BuildContext context}) {
  return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.chevron_left,
        color: secondaryColor,
        size: 0.06 * heightOfScreen,
      ));
}

/**
 * Function that returns an exit button for the admin pages to return from any
 * of them to the actions page.
 */

IconButton getExitButtonAdmin({required BuildContext context}) {
  return IconButton(
      onPressed: () {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 0.25*heightOfScreen,
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Are you sure you want to exit?',style:getSubheadingStyleYellow(),),
                    Text('Your progress will not be saved', style: getNormalTextStyleBlue(),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [SizedBox(
                        height: getHeightOfSmallButton(),
                        width: getWidthOfSmallButton(),
                        child: ElevatedButton(
                          style: yellowButtonStyle,
                          child:Text('No', style: getNormalTextStyleBlue(),),
                          onPressed: () {Navigator.pop(context);},
                        ),
                      ),
                        SizedBox(
                          height: getHeightOfSmallButton(),
                          width: getWidthOfSmallButton(),
                          child: ElevatedButton(
                            style: greyButtonStyle,
                            child:Text('Yes', style: getNormalTextStyleBlue(),),
                            onPressed: () => print('popo'),
                          ),
                        ),],
                    )
                  ],

                ),
              );
            }
        );
      }
      ,
      icon: Icon(
        Icons.clear,
        color: secondaryColor,
        size: 0.05 * heightOfScreen,
      ));
}

/**
 * This function Retrieves a card with the name of the course specified.
 *
 * Yoy need to Specify the width of the card as well as the height of the sized
 * box containing everything
 *
 * For now the card does nothing when clicked however in the future we should
 * be able to redirect the user to the course using the nameOfCourse
 */

Card getCardForUnsavedCourse(
    {required String nameOfCourse,
    required double widthOfCard,
    required double heightOfCard}) {
  return Card(
    color: primaryColor,
    borderOnForeground: true,
    shape: new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    child: InkWell(
      splashColor: secondaryColor,
      onTap: () {
        debugPrint('Card tapped.');
      },
      child: SizedBox(
        height: heightOfCard,
        width: widthOfCard,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Align(alignment: Alignment.centerRight, child: SaveButton()),
          Padding(
            padding: EdgeInsets.only(
                left: 0.05 * widthOfCard, bottom: heightOfCard * 0.05),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('$nameOfCourse', style: getNormalTextStyleWhite())),
          ),
        ]),
      ),
    ),
  );
}

/**
 * This class defines the save button of the course cards. Logic for saving/unsaving courses has not yet been implemented
 * V1.0 (2/2/2022) just changes state
 */
class SaveButton extends StatefulWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _filled = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        //Do whatever logic in the future
        setState(() {
          _filled = !_filled;
        });
      },
      icon: _filled
          ? Icon(
              Icons.bookmark,
              color: secondaryColor,
            )
          : Icon(
              Icons.bookmark_border,
              color: secondaryColor,
            ),
    );
  }
}

/**
 * Gets a tapable card with the name of the category. You have to specify the
 * width and the height.
 *
 * V 1.0 (2/8/22) Does nothing when tapped
 */
Card getCardForCategory(
    {required String nameOfCategory,
    required double widthOfCard,
    required double heightOfCard}) {
  return Card(
    color: primaryColor,
    borderOnForeground: true,
    shape: new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    child: InkWell(
      splashColor: secondaryColor,
      onTap: () {
        debugPrint('Redirected to category bla bla.');
      },
      child: SizedBox(
        width: widthOfCard,
        height: heightOfCard,
        child: Align(
            alignment: Alignment.center,
            child: Text('$nameOfCategory', style: getNormalTextStyleWhite())),
      ),
    ),
  );
}

/**
 * Getter fot a notification card. We need to specify de username and the course
 * he has completed so it appears as the info displayed. Width and height need
 * to be specified.
 */

Card getCardForNotification(
    {required String username,
    required String nameOfCourse,
    required double widthOfCard,
    required double heightOfCard}) {
  return Card(
    color: primaryColor,
    borderOnForeground: true,
    shape: new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    child: InkWell(
      splashColor: secondaryColor,
      onTap: () {
        debugPrint('Redirected to course bla bla.');
      },
      child: SizedBox(
          width: widthOfCard,
          height: heightOfCard,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 0.025 * widthOfCard, right: 0.025 * widthOfCard),
              child: Avatar(
                  url: 'https://robohash.org/$username',
                  size: widthOfScreen * 0.1),
            ),
            Flexible(
              child: Text(
                  '$username just completed a course on $nameOfCourse. ${getRandomEncouragingMessage()}',
                  style: getNormalTextStyleWhite()),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.025 * widthOfCard, right: 0.025 * widthOfCard),
              child: Icon(
                Icons.password,
                color: secondaryColor,
              ),
            ),
          ])),
    ),
  );
}

/**
 * This function returns a random String contained in a map defined in
 * k_values. This maps contains a fixed amount of encouraging messages to create
 * the notification cards
 */
String? getRandomEncouragingMessage() {
  return encouragingMessages[Random().nextInt(encouragingMessages.length - 1)];
}

/**
 * This widget is the optionButton used in the course flow
 * Which allows the user to exit the course saving the progress
 * or exit it whithout saving the progress
 */
Widget getOptionsButton(
{required BuildContext context, required String courseTitle, required String categoryTitle, required int question, required int numberOfQuestions}) {
  return IconButton(
      icon: Icon(
        Icons.menu,
        color: primaryColor,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(top: 0.1*widthOfScreen, bottom: 0.1*widthOfScreen),
                height: 0.4*heightOfScreen,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      categoryTitle,
                      style: getNormalTextStyleBlue(),
                    ),
                    Text(
                      courseTitle,
                      style: getSubheadingStyleYellow(),
                    ),
                    getCirclesProgressBarForPauseMenu(position: question, numberOfCircles: numberOfQuestions),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        SizedBox(
                          height: getHeightOfSmallButton(),
                          width: getWidthOfSmallButton(),
                          child: ElevatedButton(
                            style: yellowButtonStyle,
                            child:Text('Save', style: getNormalTextStyleBlue(),),
                            onPressed: () => print('popo'),
                          ),
                        ),
                        SizedBox(width: 0.06*widthOfScreen,),
                        SizedBox(
                          height: getHeightOfSmallButton(),
                          width: getWidthOfSmallButton(),
                          child: ElevatedButton(
                            style: greyButtonStyle,
                            child: Text('Exit', style: getNormalTextStyleBlue(),),
                            onPressed: () => print('popo'),
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: getHeightOfLargeButton(),
                      width: getWidthOfLargeButton(),
                      child: ElevatedButton(
                        style: blueButtonStyle,
                        child:Text('Resume', style: getNormalTextStyleWhite(),),
                        onPressed: () => print('popo'),
                      ),
                    )
                  ],
                ),
              );
            });
      });
}



/**
 * Function that returns a grey box with rounded corners containing a child
 * specified in the param. Used in the app to display different types of
 * text
 */
Widget getGreyTextHolderContainer({required Widget child}){
  return Container(
    padding: EdgeInsets.all(widthOfScreen*0.02),
    decoration: new BoxDecoration(

        color: quinaryColor,
        borderRadius: new BorderRadius.all(
          Radius.circular(0.05 * widthOfScreen),
        )),
    child: child,
  );
}

/**
 * Function that returns the Next Button. You need to specify
 * the function to execute when pressing it
 */
Widget getNextButton({required void Function() todo, required bool large}){
  return SizedBox(
      height:large? getHeightOfLargeButton(): getHeightOfSmallButton(),
      width: large? getWidthOfLargeButton():getWidthOfSmallButton(),
      child: ElevatedButton(
        onPressed: todo,
        child: Text('Next', style: getNormalTextStyleBlue()),
        style: greyButtonStyle,
      ));
}

/**
 * Function that returns the Add question Button.
 */

Widget getAddQuestionButton({required void Function() todo}){
  return SizedBox(
      height: getHeightOfLargeButton(),
      width: getWidthOfLargeButton(),
      child: ElevatedButton(
        onPressed: todo,
        child: Text('Add Question', style:  getNormalTextStyleBlue()),
        style: yellowButtonStyle,
      ));
}

/**
 * GROUP PAGE
 * Function returns an orange notification indicator if there are unread notifications in the group page.
 * Takes in a bool that signals if there are unread notifications or not
 */
Container getNotification(bool notification) {
  if (!notification) {
    return Container(height: 5.0, width: 5.0,color: Colors.transparent,);
  }
  return Container(
    height: 10.0,
    width: 10.0,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: secondaryColor,
    ),
  );
}

// /**
//  * GROUP PAGE
//  * Function returns a list tile for a group.
//  * It requires an image path and a group name as well as a bool if there are unread notifications.
//  * must pass context
//  */
// Widget buildGroupTile({ required BuildContext context, required String groupName, required String imagePath, bool notification = false}) {
//   return ListTile(
//     leading: CircleAvatar(
//       backgroundImage: AssetImage(imagePath),
//       backgroundColor: Colors.transparent,
//     ),
//     title: Text(
//       groupName,
//       style: const TextStyle(
//         fontSize: 20,
//         color: primaryColor,
//         fontFamily: 'Roboto',
//       ),
//     ),
//     trailing: Row(
//       children: [
//         getNotification(notification),
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Icon(
//             Icons.arrow_forward_ios,
//             color: primaryColor,
//             size: 30.0,
//           ),
//         ),
//       ],
//       mainAxisSize: MainAxisSize.min,
//     ),
//     onTap: () {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupName: groupName,)));
//     },
//   );
// }