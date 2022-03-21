// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentCourse _$CurrentCourseFromJson(Map<String, dynamic> json) =>
    CurrentCourse(
      courseID: json['courseID'] as String,
      progress:
          (json['progress'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$CurrentCourseToJson(CurrentCourse instance) =>
    <String, dynamic>{
      'courseID': instance.courseID,
      'progress': instance.progress,
    };
