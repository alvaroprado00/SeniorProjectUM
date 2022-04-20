import 'dart:math';

import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/globals.dart' as globals;
import 'package:cyber/model/question.dart';
import 'package:cyber/model/user_custom.dart';
import 'package:cyber/view/courses/fill_in_the_blanks_question_page.dart';
import 'package:cyber/view/courses/multiple_choice_question_page.dart';
import 'package:cyber/view/courses/overview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../config/fixed_values.dart';
import 'k_values.dart';

Function nextQuestion = (BuildContext context) async {
  if (globals.activeCourse!.numberOfQuestions >= globals.activeQuestionNum!) {
    //I get the question in the new-course
    Question q =
        globals.activeCourse!.questions[globals.activeQuestionNum! - 1];

    //Once I have the first question I check what type of question it is
    //to navigate to the appropriate page

    if (q.typeOfQuestion == TypeOfQuestion.multipleChoice) {
      Navigator.pushNamedAndRemoveUntil(
          context, MultipleChoiceQuestionPage.routeName, (r) => false,
          arguments: q);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, FillInTheBlanksQuestionPage.routeName, (r) => false,
          arguments: q);
    }
  } else {
    ActiveUserController activeUserController =
        Get.find<ActiveUserController>();
    final SaveCompletedCourseArgs args =
        await activeUserController.saveCompletedCourse();
    Navigator.pushNamedAndRemoveUntil(context, Overview.routeName, (r) => false,
        arguments: args);
  }
};

/**
 * Validator for TextFormField. It verifies the value is not empty
 */
String? validatorForEmptyTextField(value) {
  if (value == null || value.isEmpty) {
    return 'Enter some text.';
  } else {
    return null;
  }
}

/**
 * Validates the value is not null or empty and at least
 * 6 characters long
 */
String? validatorForPassword(value) {
  if (value == null || value.isEmpty) {
    return 'Enter some text.';
  } else if (value.length < 6) {
    return 'Password should be at least 6 characters long.';
  }
  return null;
}

/**
 * Validator for TextFormField. It verifies the value is not empty
 */
String? validatorForEmail(String? val) {
  if (val == null || val.isEmpty) {
    return 'Field is required.';
  } else if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(val)) {
    return 'Please use a valid email.';
  } else {
    return null;
  }
}

/**
 * Validator for URL. It checks if the textFormField is not empty and
 * the value that holds is a valid URL
 */
String? validatorForURL(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text.';
  } else if (Uri.parse(value).isAbsolute != true) {
    return 'Enter a valid URL.';
  }
  return null;
}

/**
 * Validator for EXP points. It checks if the textFormField is not empty and
 * the value is a int between 0 and 1000
 */
String? validatorForExp(value) {
  value = int.tryParse(value);
  if (value == null) {
    return 'Number';
  } else if (value < 0 || value > 1000) {
    return '[0-1000]';
  }
  return null;
}

/**
 * Validator for any text form field that needs a positive number to be
 * the input
 */

String? validatorForPositiveNumber(value) {
  value = int.tryParse(value);
  if (value == null) {
    return 'Please enter a number.';
  } else if (value < 0) {
    return 'Enter a positive number.';
  }
  return null;
}

/**
 * Validator for the text form field where the right question of a multiple
 * choice is specified. It requires the input to be an int within the range
 * [1-4]
 */
String? validatorForRightOption(value) {
  value = int.tryParse(value);
  if (value == null) {
    return 'Please enter a number.';
  } else if (value < 1 || value > 4) {
    return 'The right option must be between [1-4].';
  }
  return null;
}

/**
 * This function returns a random String contained in a map defined in
 * k_values. This maps contains a fixed amount of encouraging messages to create
 * the notification cards
 */
String? getRandomEncouragingMessage() {
  return encouragingMessages[Random().nextInt(encouragingMessages.length - 1)];
}

String? getRandomUpdateMessage(String courseName) {
  return updateMessages[Random().nextInt(updateMessages.length - 1)]
          .toString() +
      courseName +
      ". " +
      getRandomEncouragingMessage().toString();
}

/**
 * Function that returns a random string of the length specified
 */
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));

String getDateCreatedForGroup() {
  DateTime today = DateTime.now();
  String day = today.day.toString();
  String month = months[(today.month) - 1];
  String year = today.year.toString();

  return "${day} ${month} ${year}";
}

String? groupCodeValidator(val) {
  String groupCodePattern = r'(^([a-z0-9]{8})$)';
  RegExp regex = new RegExp(groupCodePattern);
  if (val.length == 0) {
    return "Group Codes must be 8 digits long.";
  } else if (!regex.hasMatch(val)) {
    return "Please enter a valid Group Code.";
  }
  return null;
}

// /**
//  * Function to generate a random Group Code using uid v4. If uid exists in
//  * Firebase it will recursively find a new one until it is unique.
//  */
// String getGroupCode() async {
//   final GroupController _groupController = new GroupController();
//   var uuid = new Uuid();
//   String groupCode = uuid.v4().substring(0,8);
//   ;
// }
