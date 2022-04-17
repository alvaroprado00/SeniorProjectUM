import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/completed_course.dart';
import 'package:cyber/model/current_course.dart';
import 'package:cyber/model/level.dart';
import 'package:get/get.dart';

import '../config/fixed_values.dart';
import '../model/badge.dart';
import '../model/user_custom.dart';
import '../view/util/functions.dart';

class ActiveUserController extends GetxController {
  final username = 'username'.obs;
  final profilePictureActive = 'profilePictureActive'.obs;
  final level = Level(xpEarnedInLevel: 0, levelNumber: 0, totalXP: 0).obs;
  final email = 'email@gmail.com'.obs;
  final isAdmin = true.obs;
  final userGroups = <String>[].obs;
  final coursesSaved = <String>[].obs;
  final completedCourses = <CompletedCourse>[].obs;
  final collectedBadges = <Badge>[].obs;
  final collectedAvatars = <String>[].obs;
  final currentCourse = Rxn<CurrentCourse?>();

  @override
  void onInit() {
    super.onInit();

    username.value = activeUser!.username;
    profilePictureActive.value = activeUser!.profilePictureActive;
    level.value = activeUser!.level;
    email.value = activeUser!.email;
    isAdmin.value = activeUser!.isAdmin;
    userGroups.value = activeUser!.userGroups;
    coursesSaved.value = activeUser!.coursesSaved;
    currentCourse.value = activeUser!.currentCourse;
    completedCourses.value = activeUser!.completedCourses;
    collectedBadges.value = activeUser!.collectedBadges;
    collectedAvatars.value = activeUser!.collectedAvatars;

  }

  getNumBadges() {
    return this.collectedBadges.length;
  }

  getNumAvatars() {
    return this.collectedAvatars.length;
  }

  getTotalPoints() {
    return this.level.value.totalXP;
  }

  isCompleted({required String courseID}) {
    for (CompletedCourse cc in this.completedCourses.value) {
      if (cc.courseID == courseID) {
        return true;
      }
    }

    return false;
  }

  isSaved({required String courseID}) {
    return this.coursesSaved.contains(courseID);
  }

  bool isCurrentCourse({required String courseID}) {
    if (this.currentCourse.value != null &&
        this.currentCourse.value!.courseID == courseID) {
      return true;
    } else {
      return false;
    }
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
    int i = 0;

    for (CompletedCourse completed in this.completedCourses) {
      if (courseIDs.contains(completed.courseID)) {
        i = i + completed.experiencePointsEarned;
      }
    }
    return i;
  }

  unsaveCourse({required String courseID}) {
    this.coursesSaved.remove(courseID);
    UserController.updateSimpleUserField(
        nameOfField: 'coursesSaved', field: this.coursesSaved);
  }

  saveCourse({required String courseID}) {
    this.coursesSaved.add(courseID);
    UserController.updateSimpleUserField(
        nameOfField: 'coursesSaved', field: this.coursesSaved);
  }

  Future<void> updateCurrentCourse() async {
    CurrentCourse cc =
        CurrentCourse(courseID: activeCourse!.id!, progress: userProgress);
    this.currentCourse.value = cc;
    await UserController.updateComplexUserField(
        nameOfField: 'currentCourse', field: cc);
  }

  Future updateProfilePictureActive({required String newPicture}) {
    this.profilePictureActive.value = newPicture;
    return UserController.updateSimpleUserField(
        nameOfField: 'profilePictureActive', field: newPicture);
  }

  Future signOut() {
    //We need to dispose the active user controller since
    //there is no longer an active user

    this.dispose();
    return UserController.signOutUser();
  }

  Future delete() {
    //No active user, so we delete this controller
    this.dispose();
    return UserController.deleteActiveUser();
  }

  Future saveCompletedCourse() async {
    bool levelUp = false;
    bool earnedBadge = false;

    //This is to check that the user has completed the active new-course
    //If the method is called by error does nothing
    if (activeCourse == null) {
      return false;
    } else if (activeCourse!.numberOfQuestions != userProgress.length) {
      return false;
    }

    //Calculate number of questions right
    int questionsRight = 0;
    for (bool answer in userProgress) {
      if (answer) {
        questionsRight++;
      }
    }

    //Calculate xpEarned and percentage
    int xpEarned = (((activeCourse!.experiencePoints.toDouble()) /
                activeCourse!.numberOfQuestions) *
            questionsRight)
        .round();

    if (activeCourse!.isFeatured!) {
      xpEarned = xpEarned * 2;
    }

    int percentageCompleted =
        ((questionsRight.toDouble() / activeCourse!.numberOfQuestions) * 100)
            .round();

    //Before creating the completed new-course, we check if the user has already done
    //the new-course and has a better rate of correct answers

    int xpEarnedLastTime = 0;
    int xpBalance = 0;
    bool earnedBadgeLastTime = false;

    int positionOfCourseToDelete = 0;
    bool deleteCourse = false;
    for (CompletedCourse cCourse in this.completedCourses.value) {
      if (cCourse.courseID == activeCourse!.id) {
        xpEarnedLastTime = cCourse.experiencePointsEarned;

        if (xpEarnedLastTime >= xpEarned) {
          //Exit the function because nothing is going to change
          return SaveCompletedCourseArgs(
              levelUp: false, earnedBadge: false, balanceXP: 0);
        } else {
          //In this case the user has already done the new-course but worse

          //We save the xpPoints he earned and check if he earned the badge
          xpEarnedLastTime = cCourse.experiencePointsEarned;
          deleteCourse = true;
          if (cCourse.percentageCompleted >= 50) {
            earnedBadgeLastTime = true;
          }
        }
      }
      if (!deleteCourse) {
        positionOfCourseToDelete++;
      }
    }

    if (deleteCourse) {
      this.completedCourses.removeAt(positionOfCourseToDelete);
    }

    xpBalance = xpEarned - xpEarnedLastTime;

    //We add the new-course to the list
    CompletedCourse completedCourse = CompletedCourse(
        answers: userProgress,
        numQuestionsRight: questionsRight,
        percentageCompleted: percentageCompleted,
        experiencePointsEarned: xpEarned,
        dateCompleted: DateTime.now(),
        courseID: activeCourse!.id!);
    this.completedCourses.add(completedCourse);

    //In case the user didn't earn the badge and now the percentage is over 50% we add the badge
    if (completedCourse.percentageCompleted >= percentageToGetBadge &&
        !earnedBadgeLastTime) {
      await this.addNewBadge();
      earnedBadge = true;
    }

    //If the user levels up we need to add a new profile pic
    if (this.level.value.updateLevel(xpToAdd: xpBalance)) {
      this.level.refresh();
      await this.addNewAvatar();
      levelUp = true;
    }
    ;

    await this.updateLevel();

    //If the user had as a current new-course this one, we need to set that
    //attribute to null
    if (this.currentCourse.value != null &&
        this.currentCourse.value!.courseID == completedCourse.courseID) {
      await this.removeCurrentCourse();
    }

    //After all of this we need to update the user in the DB
    try {
      await UserController.updateComplexListUserField(
          nameOfField: 'completedCourses', field: this.completedCourses.value);
      return SaveCompletedCourseArgs(
          levelUp: levelUp, earnedBadge: earnedBadge, balanceXP: xpBalance);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateLevel() async {
    await UserController.updateComplexUserField(
        nameOfField: 'level', field: this.level.value);
  }

  /**
   * Function to add a new avatar to the user
   */
  Future<void> addNewAvatar() async {
    this.collectedAvatars.add(getRandomString(5));
    await UserController.updateSimpleUserField(
        nameOfField: 'collectedAvatars', field: this.collectedAvatars.value);
  }

  /**
   * Function to add a new badge to the user
   */
  Future<void> addNewBadge() async {
    Badge newBadge = Badge(
        courseID: activeCourse!.id!,
        picture: activeCourse!.badgeIcon,
        timeEarned: DateTime.now());
    this.collectedBadges.add(newBadge);
    await UserController.updateComplexListUserField(
        nameOfField: 'collectedBadges', field: this.collectedBadges.value);
  }

  /**
   * Function to set the currentCourse to null
   */
  Future<void> removeCurrentCourse() async {
    this.currentCourse.value = null;
    await UserController.updateSimpleUserField(
        nameOfField: 'currentCourse', field: null);
  }

  /**
   * Function to change the username of the user
   */
  Future changeUsername({required String newUsername}) async {

    return UserController.updateUsername(newUsername: newUsername).then((value){

      if(value is bool){
        if(value){
          this.username.value = newUsername;
          return 'Username updated';
        }
        return 'Error updating username';
      }
      return value;
    }).catchError((error) {
      print('An error occurred when updating the username');
      return 'Error occurred';
    });
  }


  Future<void> updateUserGroups({required String groupCode}) {
    this.userGroups.value.add(groupCode);
    var res = UserController.addGroupCodeToUser(groupCode: [groupCode]);
    update();
    return res;
  }

  removeUserFromGroup({required String groupCode}) {
    this.userGroups.value.remove(groupCode);
    update();
    userGroups.refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

}
