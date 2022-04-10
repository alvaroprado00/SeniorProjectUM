library my_project.globals;

import 'package:cyber/model/user_custom.dart';

import 'model/course.dart';

Course? activeCourse;

int? activeQuestionNum;

List<bool> userProgress = [];

int? newQuestionNum;

Course? newCourse;

UserCustom? activeUser;

late final String userMessagingToken;
