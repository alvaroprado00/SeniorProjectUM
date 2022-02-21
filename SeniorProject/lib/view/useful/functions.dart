

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