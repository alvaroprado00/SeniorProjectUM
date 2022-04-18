import 'package:json_annotation/json_annotation.dart';
import 'badge.dart';

part 'custom_notification.g.dart';

@JsonSerializable()
class CustomNotification {
  final String userName;
  final Badge badge;
  final DateTime dateSent;
  final String message;

  CustomNotification({required this.userName,required this.badge,required this.dateSent,required this.message});

  factory CustomNotification.fromJson(Map<String, dynamic> json) => _$CustomNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$CustomNotificationToJson(this);

}