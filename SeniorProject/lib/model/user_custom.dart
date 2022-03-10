import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:json_annotation/json_annotation.dart';

import 'current_course.dart';
import 'badge.dart';
import 'completed_course.dart';

part 'user_custom.g.dart';

/**
 * This class is to manage our users with all their info relevant
 * Not the password since it should not be stored
 */

@JsonSerializable(explicitToJson: true)
class UserCustom {
  String email;
  String username;
  int currentXP;
  String profilePictureActive;
  List<String> collectedAvatars;
  List<Badge> collectedBadges;
  List<String> coursesSaved;
  List<CompletedCourse> completedCourses;
  CurrentCourse? currentCourse;
  bool isAdmin;

  UserCustom(
      {required String this.email,
      required String this.username,
      required int this.currentXP,
      required String this.profilePictureActive,
      required List<String> this.collectedAvatars,
      required List<Badge> this.collectedBadges,
      required List<String> this.coursesSaved,
      required List<CompletedCourse> this.completedCourses,
      required CurrentCourse? this.currentCourse,
      required bool this.isAdmin});

  factory UserCustom.fromJson(Map<String, dynamic> json) =>
      _$UserCustomFromJson(json);

  Map<String, dynamic> toJson() => _$UserCustomToJson(this);

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
      currentCourse: null,
      isAdmin: false,
    );
  }

  int getCompletedCoursesInCategory({required List<String> courseIDs}) {
    int i = 0;

    for (CompletedCourse completed in this.completedCourses) {
      if (courseIDs.contains(completed.courseID)) {
        i++;
      }
    }

    return i;
  }

  int getXPInCategory({required List<String> courseIDs}) {

    int i=0;

    for(CompletedCourse completed in this.completedCourses){
      if(courseIDs.contains(completed.courseID)){
        i=i+completed.experiencePointsEarned;
      }
    }
    return i;
  }

  void saveCourse({required String courseID}){
    this.coursesSaved.add(courseID);
    UserController.updateActiveUser();
  }

  void unsaveCourse({required String courseID}){
    this.coursesSaved.remove(courseID);
    UserController.updateActiveUser();
  }

  Future<void> updateCurrentCourse() async {
    CurrentCourse cc=CurrentCourse(courseID:activeCourse!.id! , progress: userProgress);
    this.currentCourse=cc;
    await UserController.updateActiveUser();
  }
}

//I delete them since is the same to do userCustom.completedCourses.length.toString()
/*
  String getNumOfCompletedCourses() {
    return completedCourses.length.toString();
  }
*/

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
