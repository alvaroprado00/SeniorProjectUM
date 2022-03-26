import 'package:cyber/globals.dart';
import 'package:cyber/model/completed_course.dart';
import 'package:cyber/model/level.dart';
import 'package:get/get.dart';

import '../model/badge.dart';


class ActiveUserController extends GetxController{


  final username='username'.obs;
  final profilePictureActive='profilePictureActive'.obs;
  final level=Level(xpEarnedInLevel: 0, levelNumber:0, totalXP:0).obs;
  final email='email@gmail.com'.obs;
  final isAdmin=true.obs;
  final coursesSaved=<String>[].obs;
  final completedCourses=<CompletedCourse>[].obs;
  final collectedBadges=<Badge>[].obs;
  final collectedAvatars=<String>[].obs;




  @override
  void onInit() {
    super.onInit();
    username.value=activeUser!.username;
    profilePictureActive.value=activeUser!.profilePictureActive;
    level.value=activeUser!.level;
    email.value=activeUser!.email;
    isAdmin.value=activeUser!.isAdmin;
    coursesSaved.value=activeUser!.coursesSaved;
    completedCourses.value=activeUser!.completedCourses;
    collectedBadges.value=activeUser!.collectedBadges;
    collectedAvatars.value= activeUser!.collectedAvatars;
  }

  @override
  void dispose() {

    super.dispose();
  }

}