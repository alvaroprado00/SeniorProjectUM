import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/model/level.dart';
import 'package:json_annotation/json_annotation.dart';

import '../config/fixed_values.dart';
import '../view/util/functions.dart';
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
  Level level;
  String profilePictureActive;
  List<String> userGroups;
  List<String> collectedAvatars;
  List<Badge> collectedBadges;
  List<String> coursesSaved;
  List<CompletedCourse> completedCourses;
  CurrentCourse? currentCourse;
  bool isAdmin;

  UserCustom(
      {required String this.email,
      required String this.username,
      required Level this.level,
      required String this.profilePictureActive,
      required List<String> this.userGroups,
      required List<String> this.collectedAvatars,
      required List<Badge> this.collectedBadges,
      required List<String> this.coursesSaved,
      required List<CompletedCourse> this.completedCourses,
      required CurrentCourse? this.currentCourse,
      required bool this.isAdmin});

  factory UserCustom.fromJson(Map<String, dynamic> json) =>
      _$UserCustomFromJson(json);

  Map<String, dynamic> toJson() => _$UserCustomToJson(this);

/*
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

  /**
   * This function is used to save a completed new-course in the user
   * It checks if the user had already completed the new-course.
   * It adds XP points to the user
   * It adds a badge and a profile picture in case the user achieves it
   * It returns a boolean that indicates if the user has leveled up
   *
   */
  Future saveCompletedCourse() async {

    bool levelUp=false;
    bool earnedBadge=false;
  

    //This is to check that the user has completed the active new-course
    //If the method is called by error does nothing
    if(activeCourse==null){
      return false;
    }else if(activeCourse!.numberOfQuestions!=userProgress.length){
      return false;
    }

    //Calculate number of questions right
    int questionsRight=0;
    for(bool answer in userProgress){
      if(answer){
        questionsRight++;
      }
    }

    //Calculate xpEarned and percentage
    int xpEarned=(((activeCourse!.experiencePoints.toDouble())/activeCourse!.numberOfQuestions)*questionsRight).round();
    int percentageCompleted=((questionsRight.toDouble()/activeCourse!.numberOfQuestions)*100).round();


    //Before creating the completed new-course, we check if the user has already done
    //the new-course and has a better rate of correct answers

    int xpEarnedLastTime=0;
    int xpBalance=0;
    bool earnedBadgeLastTime=false;
    
    int positionOfCourseToDelete=0;
    bool deleteCourse=false;
    for (CompletedCourse cCourse in completedCourses){
      
      if(cCourse.courseID==activeCourse!.id){
        
        if(cCourse.numQuestionsRight>=questionsRight){
          //Exit the function
          return SaveCompletedCourseArgs(levelUp: false, earnedBadge:false, balanceXP: 0);

        }else{
          //In this case the user has already done the new-course but worse
          
          //We save the xpPoints he earned and check if he earned the badge
          xpEarnedLastTime=cCourse.experiencePointsEarned;
          deleteCourse=true;
          if(cCourse.percentageCompleted>=50){
            earnedBadgeLastTime=true;
          }
          
        }
      }
      if(!deleteCourse){
        positionOfCourseToDelete++;
      }
    }
    
    if(deleteCourse){
      this.completedCourses.removeAt(positionOfCourseToDelete);
    }
    
    xpBalance=xpEarned-xpEarnedLastTime;

    //We add the new-course to the list
    CompletedCourse completedCourse=CompletedCourse(answers: userProgress,numQuestionsRight: questionsRight,percentageCompleted: percentageCompleted, experiencePointsEarned: xpEarned, dateCompleted: DateTime.now(), courseID: activeCourse!.id!);
    this.completedCourses.add(completedCourse);

    //In case the user didn't earn the badge and now the percentage is over 50% we add the badge
    if(completedCourse.percentageCompleted>=percentageToGetBadge && !earnedBadgeLastTime){
      this.addNewBadge();
      earnedBadge=true;
    }

    //If the user levels up we need to add a new profile pic
    if(this.level.updateLevel(xpToAdd: xpBalance)){
      this.addNewAvatar();
      levelUp=true;
    };

    //If the user had as a current new-course this one, we need to set that
    //attribute to null
    if(activeUser!.currentCourse!=null && activeUser!.currentCourse!.courseID==completedCourse.courseID){
      activeUser!.currentCourse=null;
    }

    //After all of this we need to update the user in the DB
    try{
       await UserController.updateActiveUser();
       return SaveCompletedCourseArgs(levelUp: levelUp, earnedBadge: earnedBadge, balanceXP: xpBalance);
    }catch(error){
      throw Exception(error.toString());
    }
  }

  /**
   * Function to add a new avatar to the user
   */
  void addNewAvatar(){
    this.collectedAvatars.add(getRandomString(5));
  }

  /**
   * Function to add a new badge to the user
   */
  void addNewBadge(){
    Badge newBadge=Badge(courseID: activeCourse!.id!, picture: activeCourse!.badgeIcon, timeEarned: DateTime.now());
    this.collectedBadges.add(newBadge);
  }

  bool isCourseSaved({required String courseID}){
    return this.coursesSaved.contains(courseID);
  }

  bool isCourseCompleted({required String courseID}){
    for(CompletedCourse cc in this.completedCourses){
      if(cc.courseID==courseID){
        return true;
      }
    }
    return false;
  }
*/

}

/**
 * This class is used to get the info from the method saveCompleted new-course.
 * It is used to know if the user has leveled up as a consequence of completing
 * the new-course and also to know if he got the score required to earn the badge and
 * the balance XP he earned
 */

class SaveCompletedCourseArgs {
  final bool levelUp;
  final bool earnedBadge;
  final int balanceXP;

  const SaveCompletedCourseArgs(
      {required bool this.levelUp,
      required bool this.earnedBadge,
      required int this.balanceXP});
}

getFakeUser() {
  return UserCustom(
    email: 'Fake@gmail.com',
    username: 'FakeUser',
    profilePictureActive: 'FakeUser',
    userGroups: groups,
    collectedBadges: fakeCollectedBadges,
    level: Level(totalXP: 1100, levelNumber: 2, xpEarnedInLevel: 100),
    collectedAvatars: fakeCollectedAvatars,
    completedCourses: fakeCompletedCourses,
    coursesSaved: fakeCoursesSaved,
    currentCourse: null,
    isAdmin: false,
  );
}

List<String> groups = ['7011ac59',];

List<Badge> fakeCollectedBadges = [
  Badge(
      courseID: "Passwords",
      picture: "keys",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      courseID: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
  Badge(
      courseID: "USB",
      picture: "cable",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      courseID: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
  Badge(
      courseID: "Passwords",
      picture: "keys",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      courseID: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
  Badge(
      courseID: "Passwords",
      picture: "keys",
      timeEarned: DateTime.parse("2022-02-02")),
  Badge(
      courseID: "Cookies",
      picture: "cookies",
      timeEarned: DateTime.parse("2022-01-24")),
];

List<String> fakeCollectedAvatars = ["hello", "good morning", "hey"];

List<CompletedCourse> fakeCompletedCourses = [
  CompletedCourse(
      answers: [
        false,
        false,
        false,
        true,
        true,
        true,
        false,
        true,
        false,
        true
      ],
      percentageCompleted: 50,
      experiencePointsEarned: 150,
      dateCompleted: DateTime.now(),
      courseID: "Password",
      numQuestionsRight: 5)
];

List<String> fakeCoursesSaved = ['Password', 'Cookies', 'USB'];
