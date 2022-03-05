// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveCourse _$ActiveCourseFromJson(Map<String, dynamic> json) => ActiveCourse(
      courseID: json['courseID'] as String,
      progress:
          (json['progress'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$ActiveCourseToJson(ActiveCourse instance) =>
    <String, dynamic>{
      'courseID': instance.courseID,
      'progress': instance.progress,
    };
