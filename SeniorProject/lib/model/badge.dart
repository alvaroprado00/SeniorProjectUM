import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge {
  String course;
  String picture;
  DateTime timeEarned;

  Badge({required String this.course, required String this.picture, required DateTime this.timeEarned});

  void getBadge(String picture) {
    FaIcon(FontAwesomeIcons.car);
  }
  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}