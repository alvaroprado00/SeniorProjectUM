import 'dart:math';

import 'package:cyber/view/k_values.dart';
import 'package:flutter/material.dart';

import 'avatar.dart';
import 'k_colors.dart';
import 'k_styles.dart';

/**
 * Validator for TextFormField. It verifies the value is not empty
 */
String? validatorForEmptyTextField(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

/**
 * Function to get an Input Decoration for a text field providing the Icon and the hint Text wanted
 */
InputDecoration getInputDecoration(
    {required String hintText,
    required Icon icon,
    required double widthOfScreen}) {
  return InputDecoration(
      filled: true,
      fillColor: tertiaryColor,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: tertiaryColor, width: 1.0),
      ),
      prefixIcon: icon,
      hintStyle: getTexFieldTextStyle(),
      contentPadding: EdgeInsets.only(
          top: 0.08 * widthOfScreen, left: 0.08 * widthOfScreen));
}

/**
 * Function to create a row of dots. The number specified in position will be colored yellow.
 * Used as a progress Indicator
 * Uses the function getCircle()
 */
Widget getCirclesProgressBar(
    {required int position,
    required int numberOfCircles,
    required double widthOfScreen}) {
  final children = <Widget>[];

  for (var i = 1; i <= numberOfCircles; i++) {
    if (position == i) {
      children
          .add(getCircle(color: secondaryColor, widthOfScreen: widthOfScreen));
    } else {
      children
          .add(getCircle(color: quinaryColor, widthOfScreen: widthOfScreen));
    }
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: children,
  );
}

Widget getCircle({required Color color, required double widthOfScreen}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
    child: SizedBox(
      width: 0.02 * widthOfScreen,
      height: 0.02 * widthOfScreen,
      child: Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

/**
 * Function that returns an back button. You need to specify the context so the
 * function in the onPressed parm makes sense. You also need to provide the height
 * of the Screen
 */

IconButton getBackButton(
    {required BuildContext context, required double heightOfScreen}) {
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
 * This function Retrieves a card with the name of the course specified.
 *
 * Yoy need to Specify the width of the card as well as the height of the sized
 * box containing the text. Be careful to think about the height of the card
 * you need to include the row containg the icon
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
                child: Text('$nameOfCourse',
                    style:
                        getNormalTextStyleWhite())),
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
            child: Text('$nameOfCategory',
                style:
                    getNormalTextStyleWhite())),
      ),
    ),
  );
}



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
              padding:EdgeInsets.only(left:0.025*widthOfCard ,right:0.025*widthOfCard ),
              child: Avatar(
                  url: 'https://robohash.org/$username',
                  size: widthOfScreen * 0.1),
            ),

            Flexible(
              child: Text('$username just completed a course on $nameOfCourse. ${getRandomEncouragingMessage()}',
                  style:
                  getNormalTextStyleWhite()),
            ),
            
           Padding(
             padding:EdgeInsets.only(left:0.025*widthOfCard ,right:0.025*widthOfCard ),
             child: Icon(Icons.password, color: secondaryColor,),
           ),

          ])),
    ),
  );
}

String? getRandomEncouragingMessage(){
return encouragingMessages[Random().nextInt(encouragingMessages.length-1)];
}