/**
 * File used to store color maps to use theme for the app's theme
 * It also contains constants defining the color palette used in the project
 */

import 'package:flutter/material.dart';

// These maps are required to use the ColorScheme in the main.dart

Map<int, Color> primaryBlue = {
  50: Color.fromRGBO(20, 33, 61, .1),
  100: Color.fromRGBO(20, 33, 61, .2),
  200: Color.fromRGBO(20, 33, 61, .3),
  300: Color.fromRGBO(20, 33, 61, .4),
  400: Color.fromRGBO(20, 33, 61, .5),
  500: Color.fromRGBO(20, 33, 61, .6),
  600: Color.fromRGBO(20, 33, 61, .7),
  700: Color.fromRGBO(20, 33, 61, .8),
  800: Color.fromRGBO(20, 33, 61, .9),
  900: Color.fromRGBO(20, 33, 61, 1),
};

Map<int, Color> secondaryYellow = {
  50: Color.fromRGBO(252, 163, 17, .1),
  100: Color.fromRGBO(252, 163, 17, .2),
  200: Color.fromRGBO(252, 163, 17, .3),
  300: Color.fromRGBO(252, 163, 17, .4),
  400: Color.fromRGBO(252, 163, 17, .5),
  500: Color.fromRGBO(252, 163, 17, .6),
  600: Color.fromRGBO(252, 163, 17, .7),
  700: Color.fromRGBO(252, 163, 17, .8),
  800: Color.fromRGBO(252, 163, 17, .9),
  900: Color.fromRGBO(252, 163, 17, 1),
};

//These are our main colors used in the app

const Color primaryColor = Color(0xFF14213D);
const Color secondaryColor = Color(0xFFFCA311);
const Color tertiaryColor = Colors.white;
const Color quaternaryColor = Color(0xFFF8E3C0);
const Color quinaryColor = Color(0xFFE5E5E5);
