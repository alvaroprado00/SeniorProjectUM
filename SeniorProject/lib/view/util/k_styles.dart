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

double getHeightOfLargeButton() {
  return heightOfScreen * 0.07;
}

double getWidthOfLargeButton() {
  return 0.94 * widthOfScreen;
}

double getHeightOfSmallButton() {
  return heightOfScreen * 0.07;
}

double getWidthOfSmallButton() {
  return 0.43 * widthOfScreen;
}

TextStyle getTexFieldTextStyle() {
  return TextStyle(
      color: quaternaryColor,
      fontFamily: fontFamily,
      fontSize: 0.05 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSubheadingStyleYellow() {
  return TextStyle(
      color: secondaryColor,
      fontFamily: fontFamily,
      fontSize: 0.06 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSubheadingStyleWhite() {
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.06 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSubheadingStyleBlue() {
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.06 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getHeadingStyleWhite() {
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.08 * widthOfScreen,
      fontWeight: FontWeight.w300);
}

TextStyle getHeadingStyleBlue() {
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.07 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleBlue() {
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleBlueBold() {
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045 * widthOfScreen,
      fontWeight: FontWeight.bold);
}

TextStyle getNormalTextStyleBlueItalicBold() {
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045 * widthOfScreen,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500);
}

TextStyle getNormalTextStyleWhite() {
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleYellow() {
  return TextStyle(
      color: secondaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleYellowBold() {
  return TextStyle(
      color: secondaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045 * widthOfScreen,
      fontWeight: FontWeight.bold);
}

TextStyle getSmallTextStyle() {
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.04 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSmallTextStyleBlue() {
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.04 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSmallTextStyleGrey() {
  return TextStyle(
      color: Colors.grey,
      fontFamily: fontFamily,
      fontSize: 0.04 * widthOfScreen,
      fontWeight: FontWeight.w400);
}

ButtonStyle yellowButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(secondaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

ButtonStyle greyButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(quinaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

ButtonStyle transparentButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      side: BorderSide(color: quinaryColor, width: 1),
      borderRadius: BorderRadius.circular(10.0),
    )));

ButtonStyle blueButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(primaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

ButtonStyle whiteButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(tertiaryColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

/**
 * Function to get an Input Decoration for a text field providing the Icon and the hint Text wanted
 * It is used for any other TextFormField different than the password one
 */
InputDecoration getInputDecoration(
    {required String hintText, required Icon icon}) {
  return InputDecoration(
      filled: true,
      fillColor: tertiaryColor,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: tertiaryColor, width: 1.0),
      ),
      prefixIcon: icon,
      hintStyle: getTexFieldTextStyle(),
      contentPadding: EdgeInsets.only(
          top: 0.08 * widthOfScreen, left: 0.08 * widthOfScreen));
}

InputDecoration inputDecorationForLongText = InputDecoration(
    filled: true,
    fillColor: tertiaryColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: tertiaryColor, width: 1.0),
    ),
    contentPadding: EdgeInsets.all(10));
