// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      totalXP: json['totalXP'] as int? ?? 0,
      xpInLevel: json['xpInLevel'] as int,
      levelNumber: json['levelNumber'] as int,
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'totalXP': instance.totalXP,
      'xpInLevel': instance.xpInLevel,
      'levelNumber': instance.levelNumber,
    };
