// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      totalXP: json['totalXP'] as int? ?? 0,
      xpEarnedInLevel: json['xpEarnedInLevel'] as int,
      levelNumber: json['levelNumber'] as int,
      xpAvailableInLevel: json['xpAvailableInLevel'] as int,
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'totalXP': instance.totalXP,
      'xpEarnedInLevel': instance.xpEarnedInLevel,
      'levelNumber': instance.levelNumber,
      'xpAvailableInLevel': instance.xpAvailableInLevel,
    };
