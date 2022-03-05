// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCustom _$UserCustomFromJson(Map<String, dynamic> json) => UserCustom(
      email: json['email'] as String,
      username: json['username'] as String,
      currentXP: json['currentXP'] as int,
      profilePictureActive: json['profilePictureActive'] as String,
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
      activeCourse: json['activeCourse'] == null
          ? null
          : ActiveCourse.fromJson(json['activeCourse'] as Map<String, dynamic>),
      isAdmin: json['isAdmin'] as bool,
    );

Map<String, dynamic> _$UserCustomToJson(UserCustom instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'currentXP': instance.currentXP,
      'profilePictureActive': instance.profilePictureActive,
      'collectedAvatars': instance.collectedAvatars,
      'collectedBadges': instance.collectedBadges,
      'coursesSaved': instance.coursesSaved,
      'completedCourses': instance.completedCourses,
      'activeCourse': instance.activeCourse,
      'isAdmin': instance.isAdmin,
    };
