import 'package:json_annotation/json_annotation.dart';

part 'completed_course.g.dart';

@JsonSerializable()
class CompletedCourse {
  final List<bool> answers;
  final int numQuestionsRight;
  final int experiencePointsEarned;
  final int percentageCompleted;
  final DateTime dateCompleted;
  final String courseID;

  const CompletedCourse(
      {required List<bool> this.answers,
      required int this.numQuestionsRight,
      required int this.percentageCompleted,
      required int this.experiencePointsEarned,
      required DateTime this.dateCompleted,
      required String this.courseID});

  factory CompletedCourse.fromJson(Map<String, dynamic> json) =>
      _$CompletedCourseFromJson(json);
  Map<String, dynamic> toJson() => _$CompletedCourseToJson(this);
}
