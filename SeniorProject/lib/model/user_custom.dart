import 'package:json_annotation/json_annotation.dart';

import 'active_course.dart';
import 'badge.dart';
import 'completed_course.dart';

part 'user_custom.g.dart';

/**
 * This class is to manage our users with all their info relevant
 * Not the password since it should not be stored
 */

@JsonSerializable()
class UserCustom {
  String email;
  String username;
  int currentXP;
  String profilePictureActive;
  List<String> collectedAvatars;
  List<Badge> collectedBadges;
  List<String> coursesSaved;
  List<CompletedCourse> completedCourses;
  ActiveCourse? activeCourse;
  bool isAdmin;


  UserCustom({
    required String this.email,
    required String this.username,
    required int this.currentXP,
    required String this.profilePictureActive,
    required List<String> this.collectedAvatars,
    required List<Badge> this.collectedBadges,
    required List<String> this.coursesSaved,
    required List<CompletedCourse> this.completedCourses,
    required ActiveCourse? this.activeCourse,
    required bool this.isAdmin
  });

  factory UserCustom.fromJson(Map<String, dynamic> json) => _$UserCustomFromJson(json);

  Map<String, dynamic> toJson() => _$UserCustomToJson(this);

}

  //I delete them since is the same to do userCustom.completedCourses.length.toString()
/*
  String getNumOfCompletedCourses() {
    return completedCourses.length.toString();
  }
*/



getFakeUser() {
  return UserCustom(
      email: 'Fake@gmail.com',
      username: 'FakeUser',
      profilePictureActive: 'FakeUser',
      collectedBadges: fakeCollectedBadges,
      currentXP: 470,
      collectedAvatars: fakeCollectedAvatars,
      completedCourses: fakeCompletedCourses,
      coursesSaved: fakeCoursesSaved,
      activeCourse: null,
      isAdmin: false,
  );
}

List<Badge> fakeCollectedBadges = [
  Badge(
      course: "Passwords",
      picture: "keys",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      course: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
  Badge(
      course: "USB",
      picture: "cable",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      course: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
  Badge(
      course: "Passwords",
      picture: "keys",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      course: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
  Badge(
      course: "Passwords",
      picture: "keys",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      course: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
];

List<String> fakeCollectedAvatars = ["hello", "good morning", "hey"];

List<CompletedCourse> fakeCompletedCourses = [
  CompletedCourse(
      answers: [false, false, false],
      experiencePointsEarned: 600,
      dateCompleted: DateTime.parse("2022-11-20"),
      courseID: "Password")
];

List<String> fakeCoursesSaved = ['Password', 'Cookies', 'USB'];
