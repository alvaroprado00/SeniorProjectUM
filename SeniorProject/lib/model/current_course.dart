import 'package:json_annotation/json_annotation.dart';

part 'current_course.g.dart';

@JsonSerializable()
class CurrentCourse {
  String courseID;
  List<bool> progress;

  CurrentCourse(
      {required String this.courseID, required List<bool> this.progress});

  factory CurrentCourse.fromJson(Map<String, dynamic> json) =>
      _$CurrentCourseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentCourseToJson(this);
}
