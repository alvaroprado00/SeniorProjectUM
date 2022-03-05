import 'package:json_annotation/json_annotation.dart';

part 'active_course.g.dart';

@JsonSerializable()
class ActiveCourse{

  String courseID;
  List<bool> progress;

  ActiveCourse({required String this.courseID, required List<bool> this.progress});

  factory ActiveCourse.fromJson(Map<String, dynamic> json) => _$ActiveCourseFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveCourseToJson(this);

}