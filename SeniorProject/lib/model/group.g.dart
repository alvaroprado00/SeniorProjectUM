// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
    groupCode: json['groupCode'] as String,
    groupName: json['groupName'] as String,
    groupMembers: List<String>.from(json['groupMembers']),
    groupImageURL: json['groupImageURL'] as String,
  );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
    'groupCode': instance.groupCode,
    'groupName': instance.groupName,
    'groupMembers': instance.groupMembers,
    'groupImageURL': instance.groupImageURL,
  };