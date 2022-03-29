import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String groupCode;
  final String groupName;
  final List<String> groupMembers;
  final String groupImageURL;

  Group({
    required this.groupCode,
    required this.groupName,
    required this.groupMembers,
    required this.groupImageURL,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}