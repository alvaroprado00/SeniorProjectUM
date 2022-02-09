/**
 * In this file you can find different getters for TextStyles, ButtonStyles and
 * inputStyles.
 *
 * They cant be constants since they depend on the variable widthOfScreen,
 * heightOfScreen or even both
 */

import 'package:flutter/material.dart';
import 'k_colors.dart';
import 'k_values.dart';

const String fontFamily = 'roboto';


double getHeightOfLargeButton(){
  return heightOfScreen*0.07;
}

double getWidthOfLargeButton(){
  return 0.94*widthOfScreen;
}

TextStyle getTexFieldTextStyle(){
  return TextStyle(
      color: quaternaryColor,
      fontFamily: fontFamily,
      fontSize: 0.05*widthOfScreen,
      fontWeight: FontWeight.w400);
}
TextStyle getSubheadingStyleYellow(){
  return TextStyle(
      color: secondaryColor,
      fontFamily: fontFamily,
      fontSize: 0.05*widthOfScreen,
      fontWeight: FontWeight.w400);
}
TextStyle getSubheadingStyleWhite(){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.06*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSubheadingStyleBlue(){
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.06*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getHeadingStyleWhite(){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.08*widthOfScreen,
      fontWeight: FontWeight.w300);
}
TextStyle getHeadingStyleBlue(){
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.07*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleBlue(){
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleWhite(){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045*widthOfScreen,
      fontWeight: FontWeight.w400);
}
TextStyle getNormalTextStyleYellow(){
  return TextStyle(
      color: secondaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSmallTextStyle(){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.04*widthOfScreen,
      fontWeight: FontWeight.w400);
}

ButtonStyle largeYellowButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(secondaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

ButtonStyle largeGreyButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(quinaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

ButtonStyle largeBlueButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(primaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )));


/**
 * Function to get an Input Decoration for a text field providing the Icon and the hint Text wanted
 * It is used for any other TextFormField different than the password one
 */
InputDecoration getInputDecoration(
    {required String hintText,
      required Icon icon}) {
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