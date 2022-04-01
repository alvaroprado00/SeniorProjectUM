import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge {
  String courseID;
  String picture;
  DateTime timeEarned;

  Badge(
      {required String this.courseID,
      required String this.picture,
      required DateTime this.timeEarned});

  void getBadge(String picture) {
    FaIcon(FontAwesomeIcons.car);
  }

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  timeEarnedToString() {
    return '${this.timeEarned.month}/${this.timeEarned.day}/${this.timeEarned.year} at ${this.timeEarned.hour}:${this.timeEarned.minute}';
  }
}
