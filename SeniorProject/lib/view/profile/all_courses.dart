import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/util/cards.dart';
import 'package:flutter/material.dart';

import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class AllCoursesPage extends StatelessWidget {
  const AllCoursesPage({Key? key}) : super(key: key);


  static final String routeName='/allCourses';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        title: Text('My Courses', style: getSubheadingStyleBlue(),),
        elevation: 0,
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 0.05*heightOfScreen,),
              UserProgress(),
              SizedBox(height: 0.05*heightOfScreen,),
              CategoryCardsForUser(category: Category.info),
              SizedBox(height: 0.05*heightOfScreen,),
              CategoryCardsForUser(category: Category.web),
              SizedBox(height: 0.05*heightOfScreen,),
              CategoryCardsForUser(category: Category.socialMedia),
              SizedBox(height: 0.05*heightOfScreen,),
              CategoryCardsForUser(category: Category.devices),
              SizedBox(height: 0.05*heightOfScreen,),

            ],
          ),
        ),
      ),
    );
  }
}




class UserProgress extends StatelessWidget {
  UserProgress({Key? key,}) : super(key: key);


  final numCoursesSaved=activeUser!.coursesSaved.length;
  final numCoursesCompleted=activeUser!.completedCourses.length;
  final pointsEarned=activeUser!.level.totalXP;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:EdgeInsets.only(left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
      child: ProgressContainerThreeFields(field1: '${numCoursesSaved.toString()} Saved', field2: '${pointsEarned.toString()} Points', field3: '${numCoursesSaved.toString()} Completed'),
    );
  }

}




class CategoryCardsForUser extends StatelessWidget {
  const CategoryCardsForUser({Key? key, required Category this.category}) : super(key: key);

  final Category category;
  @override
  Widget build(BuildContext context) {

    //I create a course controller so I can call then DB in search for all the courses in a category
   //I just need to get from DB a map with <courseID-Name> so then I can build the cards
    //Each course cards needs the name of the course, the course ID and info about if it is
   //completed or saved. With that map we can get all that info using also the info of the active user

    CourseController cc=CourseController();

    return FutureBuilder(
      future: cc.getCourseNamesFromCategory(category: category),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CategoryContent( coursesInCategory:snapshot.data, nameOfCategory: categoryToString[category]!,);

        } else if (snapshot.hasError) {
        return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: getHeadingStyleBlue(),
                ),
              );
        } else {
        return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),

          );
        }
      },
    );
  }
}


class CategoryContent extends StatelessWidget {
  const CategoryContent({Key? key, required Map<String, String> this.coursesInCategory, required String this.nameOfCategory}) : super(key: key);

  final Map<String, String> coursesInCategory;
  final String nameOfCategory;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,

      children: [
        SubtitleDivider(subtitle:nameOfCategory ),
        getCards(context: context),
      ],
    );
  }

  getCards({required BuildContext context}){

    List<Widget> childrenOfRow=[];

    //If no courses in category, notify user
    if(coursesInCategory.isEmpty){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.center,

        children: [SizedBox(height: 0.05*heightOfScreen),Text('No courses in category', style: getSubheadingStyleBlue(),)],
      );
    }

    coursesInCategory.forEach((key, value) {
      bool isCompleted=activeUser!.isCourseCompleted(courseID: key);
      bool isSaved=activeUser!.isCourseSaved(courseID: key);

      //The max number of courses we are going to add is 3
      if((isCompleted|| isSaved)&& childrenOfRow.length<=3){
        //In case the user has either completed or saved the course we display the info
        childrenOfRow.add(getCardForCourse(courseID: key, isCompleted:isCompleted, isSaved: isSaved, context: context, title: value, widthOfCard: 0.4*widthOfScreen, heightOfCard: 0.12*heightOfScreen, isTemplate: false));
      }

      //If we dont have enough we place a placeholder

      if(childrenOfRow.length<3){
        int numberOfPlaceHolders=3-childrenOfRow.length;
        for(int i=0; i<numberOfPlaceHolders; i++){
          childrenOfRow.add(getCourseCardPlaceHolder());
        }
      }

      //The last thing we need to add is see all button
      childrenOfRow.add(getSeeAllButton());

    });

    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 15,
      spacing: 0.1*widthOfScreen,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: childrenOfRow,
    );
  }

  getSeeAllButton(){
    return Container(
      width: 0.4 * widthOfScreen,
      height: 0.12 * heightOfScreen,
      decoration: BoxDecoration(
          color: quinaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: IconButton(onPressed: () {print('eeey');  }, icon: Icon(Icons.add, color: secondaryColor,),),
    );


  }
}

