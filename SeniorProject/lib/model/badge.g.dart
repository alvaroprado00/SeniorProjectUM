// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
      courseID: json['courseID'] as String,
      picture: json['picture'] as String,
      timeEarned: DateTime.parse(json['timeEarned'] as String),
    );

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'courseID': instance.courseID,
      'picture': instance.picture,
      'timeEarned': instance.timeEarned.toIso8601String(),
    };
