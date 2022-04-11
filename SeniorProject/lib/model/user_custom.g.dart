// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCustom _$UserCustomFromJson(Map<String, dynamic> json) => UserCustom(
  email: json['email'] as String,
  username: json['username'] as String,
  level: Level.fromJson(json['level'] as Map<String, dynamic>),
  profilePictureActive: json['profilePictureActive'] as String,
  userGroups: (json['userGroups'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  collectedAvatars: (json['collectedAvatars'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  collectedBadges: (json['collectedBadges'] as List<dynamic>)
      .map((e) => Badge.fromJson(e as Map<String, dynamic>))
      .toList(),
  coursesSaved: (json['coursesSaved'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  completedCourses: (json['completedCourses'] as List<dynamic>)
      .map((e) => CompletedCourse.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentCourse: json['currentCourse'] == null
      ? null
      : CurrentCourse.fromJson(
      json['currentCourse'] as Map<String, dynamic>),
  isAdmin: json['isAdmin'] as bool,
);

Map<String, dynamic> _$UserCustomToJson(UserCustom instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'level': instance.level.toJson(),
      'profilePictureActive': instance.profilePictureActive,
      'userGroups': instance.userGroups.toList(),
      'collectedAvatars': instance.collectedAvatars,
      'collectedBadges':
      instance.collectedBadges.map((e) => e.toJson()).toList(),
      'coursesSaved': instance.coursesSaved,
      'completedCourses':
      instance.completedCourses.map((e) => e.toJson()).toList(),
      'currentCourse': instance.currentCourse?.toJson(),
      'isAdmin': instance.isAdmin,
    };