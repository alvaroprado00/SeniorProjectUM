import 'package:cyber/model/question.dart';
import 'package:cyber/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:cyber/view/courses/multiple_choice_question_page.dart';
import 'package:cyber/view/courses/fill_in_the_blanks_question_page.dart';


import 'k_values.dart';

Function nextQuestion=(BuildContext context){

  //I get the first question in the course
  Question q= globals.activeCourse!.questions[globals.activeQuestionNum!-1];

  //Once I have the first question I check what type of question it is
  //to navigate to the appropriate page

  if(q.typeOfQuestion==TypeOfQuestion.multipleChoice){
    Navigator.pushNamed(context, MultipleChoiceQuestionPage.routeName, arguments: q);
  }else{
    Navigator.pushNamed(context, FillInTheBlanksQuestionPage.routeName, arguments: q);
  }

};

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
 * Validator for URL. It checks if the textFormField is not empty and
 * the value that holds is a valid URL
 */
String? validatorForURL(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';

  }else if(Uri.parse(value).isAbsolute!=true){
    return 'Enter a valid URL';
  }
  return null;
}

/**
 * Validator for URL. It checks if the textFormField is not empty and
 * the value that holds is a valid URL
 */
String? validatorForExp(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a number';

  }else if(value<0 || value >1000){
    return 'Enter a number in the range [0-1000]';
  }
  return null;
}