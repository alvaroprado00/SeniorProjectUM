// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomNotification _$CustomNotificationFromJson(Map<String, dynamic> json) => CustomNotification(
  userName: json['userName'] as String,
  date: json['date'] as String,
  message: json['message'] as String,
  badge: Badge.fromJson(json['badge'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomNotificationToJson(CustomNotification instance) => <String, dynamic>{
  'userName': instance.userName,
  'date': instance.date,
  'message': instance.message,
  'badge': instance.badge.toJson(),
};