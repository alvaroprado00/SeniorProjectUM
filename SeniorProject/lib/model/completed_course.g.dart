// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedCourse _$CompletedCourseFromJson(Map<String, dynamic> json) =>
    CompletedCourse(
      numOfQuestionsWrong: json['numOfQuestionsWrong'] as int,
      questionNumbers: (json['questionNumbers'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      experiencePointsEarned: json['experiencePointsEarned'] as int,
      dateCompleted: DateTime.parse(json['dateCompleted'] as String),
      courseID: json['courseID'] as String,
    );

Map<String, dynamic> _$CompletedCourseToJson(CompletedCourse instance) =>
    <String, dynamic>{
      'numOfQuestionsWrong': instance.numOfQuestionsWrong,
      'questionNumbers': instance.questionNumbers,
      'experiencePointsEarned': instance.experiencePointsEarned,
      'dateCompleted': instance.dateCompleted.toIso8601String(),
      'courseID': instance.courseID,
    };
