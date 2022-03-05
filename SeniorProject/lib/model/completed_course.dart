import 'package:json_annotation/json_annotation.dart';

part 'completed_course.g.dart';

@JsonSerializable()
class CompletedCourse {

  //To see how the user has done on the course we will use the attribute answers
  // Number of answers: answers.lenght() To see which ones are wrong look for
  // the position of false inside list. Note that lists in dart are ordered

  final List<bool> answers;
  final int experiencePointsEarned;
  final DateTime dateCompleted;
  final String courseID;


  const CompletedCourse(
      {
      required List<bool> this.answers,
      required int this.experiencePointsEarned,
      required DateTime this.dateCompleted,
      required String this.courseID});

  factory CompletedCourse.fromJson(Map<String, dynamic> json) => _$CompletedCourseFromJson(json);
  Map<String, dynamic> toJson() => _$CompletedCourseToJson(this);
}
