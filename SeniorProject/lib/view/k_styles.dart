/*
  File used to specify different styles used throughout the whole app (text styles, button styles...)
 */
import 'package:flutter/material.dart';
import 'k_colors.dart';

const String fontFamily = 'roboto';

const TextStyle textFieldStyle = TextStyle(
    color: quaternaryColor,
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400);

const TextStyle subheadingStyleYellow = TextStyle(
    color: secondaryColor,
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400);

const TextStyle subheadingStyleWhite = TextStyle(
    color: tertiaryColor,
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400);

const TextStyle headingStyle = TextStyle(
    color: tertiaryColor,
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w300);

const TextStyle normalText = TextStyle(
    color: primaryColor,
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400);
const TextStyle smallTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    fontSize: 16,
    color: tertiaryColor);

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
