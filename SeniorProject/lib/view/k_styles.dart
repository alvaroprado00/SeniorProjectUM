/*
  File used to specify different styles used throughout the whole app (text styles, button styles...)
 */
import 'package:flutter/material.dart';
import 'k_colors.dart';

const String fontFamily = 'roboto';


double getHeightOfLargeButton({required double heightOfScreen}){
  return heightOfScreen*0.07;
}

double getWidthOfLargeButton({required double widthOfScreen}){
  return 0.94*widthOfScreen;
}

TextStyle getTexFieldTextStyle({required double widthOfScreen}){
  return TextStyle(
      color: quaternaryColor,
      fontFamily: fontFamily,
      fontSize: 0.05*widthOfScreen,
      fontWeight: FontWeight.w400);
}
TextStyle getSubheadingStyleYellow({required double widthOfScreen}){
  return TextStyle(
      color: secondaryColor,
      fontFamily: fontFamily,
      fontSize: 0.05*widthOfScreen,
      fontWeight: FontWeight.w400);
}
TextStyle getSubheadingStyleWhite({required double widthOfScreen}){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.05*widthOfScreen,
      fontWeight: FontWeight.w400);
}
TextStyle getHeadingStyleWhite({required double widthOfScreen}){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.08*widthOfScreen,
      fontWeight: FontWeight.w300);
}

TextStyle getNormalTextStyleBlue({required double widthOfScreen}){
  return TextStyle(
      color: primaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getNormalTextStyleWhite({required double widthOfScreen}){
  return TextStyle(
      color: tertiaryColor,
      fontFamily: fontFamily,
      fontSize: 0.045*widthOfScreen,
      fontWeight: FontWeight.w400);
}

TextStyle getSmallTextStyle({required double widthOfScreen}){
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
