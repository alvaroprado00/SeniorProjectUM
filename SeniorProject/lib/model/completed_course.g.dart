// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedCourse _$CompletedCourseFromJson(Map<String, dynamic> json) =>
    CompletedCourse(
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as bool).toList(),
      experiencePointsEarned: json['experiencePointsEarned'] as int,
      dateCompleted: DateTime.parse(json['dateCompleted'] as String),
      courseID: json['courseID'] as String,
    );

Map<String, dynamic> _$CompletedCourseToJson(CompletedCourse instance) =>
    <String, dynamic>{
      'answers': instance.answers,
      'experiencePointsEarned': instance.experiencePointsEarned,
      'dateCompleted': instance.dateCompleted.toIso8601String(),
      'courseID': instance.courseID,
    };
