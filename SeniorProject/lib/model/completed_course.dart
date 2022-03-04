import 'package:json_annotation/json_annotation.dart';

part 'completed_course.g.dart';

@JsonSerializable()
class CompletedCourse {
  final int numOfQuestionsWrong;
  final List<int> questionNumbers;
  final int experiencePointsEarned;
  final DateTime dateCompleted;
  final String courseID;

  const CompletedCourse(
      {required int this.numOfQuestionsWrong,
      required List<int> this.questionNumbers,
      required int this.experiencePointsEarned,
      required DateTime this.dateCompleted,
      required String this.courseID});

  factory CompletedCourse.fromJson(Map<String, dynamic> json) => _$CompletedCourseFromJson(json);
  Map<String, dynamic> toJson() => _$CompletedCourseToJson(this);
}
