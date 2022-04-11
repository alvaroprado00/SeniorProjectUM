import 'package:json_annotation/json_annotation.dart';

import 'custom_notification.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String groupCode;
  final String groupName;
  final String dateCreated;
  final List<String> groupMembers;
  final String groupImageURL;
  final List<CustomNotification> groupNotifications;

  Group({
    required this.groupCode,
    required this.groupName,
    required this.dateCreated,
    required this.groupMembers,
    required this.groupImageURL,
    required this.groupNotifications,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}