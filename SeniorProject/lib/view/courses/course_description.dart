import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart' as globals;
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../model/completed_course.dart';
import '../../model/course.dart';
import '../util/cards.dart';



class CourseDescription extends StatelessWidget {

  const CourseDescription({Key? key}) : super(key: key);

  static final routeName='/courseDescription';

  @override
  Widget build(BuildContext context) {

    final String courseID = ModalRoute.of(context)!.settings.arguments as String;


    //I need to have an instance of the Course controller to use the methods
    //defined in that class
    final courseController=CourseController();

    // Before building the page I need to get the new-course from the DB
    return Scaffold(
      backgroundColor: tertiaryColor,
      body:FutureBuilder(
        future: courseController.getCourseByID(id: courseID),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {

              //Once I get the new-course I assign its value to a global variable
              // so I can access the info from other pages easily
              globals.activeCourse=snapshot.data;
              globals.activeQuestionNum=1;
              globals.userProgress=[];

              //I check if the activeUser has the courseSaved or if its the current one
              bool isSaved=globals.activeUser!.isCourseSaved(courseID: courseID);
              bool isCurrentCourse=globals.activeUser!.isCurrentCourse(courseID: courseID);
              bool isCompleted=globals.activeUser!.isCourseCompleted(courseID: courseID);


              if(isCurrentCourse){
                globals.activeQuestionNum=globals.activeUser!.currentCourse!.progress.length+1;
                globals.userProgress=globals.activeUser!.currentCourse!.progress;
              }

              return CourseDescriptionContent(course: snapshot.data, isSaved: isSaved, isCurrentCourse: isCurrentCourse, isCompleted:isCompleted);

          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: getHeadingStyleBlue(),),
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}

/**
 * This class is built specifying a new-course in its constructor.
 * When built, it shows the info from the new-course
 */
class CourseDescriptionContent extends StatelessWidget {

  const CourseDescriptionContent({required Course this.course, required bool this.isSaved, required this.isCurrentCourse, required this.isCompleted});
  final Course course;
  final bool isSaved;
  final bool isCurrentCourse;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: widthOfScreen,
                height: 0.3 * heightOfScreen,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(course.imageURL),
                  ),
                ),
              ),
              Positioned(
                top: 0.08 * heightOfScreen,
                child: getBackButton(context: context),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.05 * widthOfScreen, right: 0.05 * widthOfScreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: getHeadingStyleBlue(),
                      ),
                      SizedBox(width: 0.35*widthOfScreen,),
                      isCompleted? Icon(Icons.check_circle_rounded, color: secondaryColor,):SizedBox(width: 0,),
                      SaveButton(isFilled: isSaved, courseID: course.id!),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${course.experiencePoints} XP',
                      style: getNormalTextStyleYellow(),
                    ),
                    SizedBox(
                      width: 0.05 * widthOfScreen,
                    ),
                    Text(
                      '${course.numberOfQuestions} Questions',
                      style: getNormalTextStyleYellow(),
                    )
                  ],
                ),
                SizedBox(height: 0.03*heightOfScreen,),

                Text(course.description.toString(),
                    style: getNormalTextStyleBlue()),

                SizedBox(height: 0.03*heightOfScreen,),
                Text(
                  'Key Outcomes',
                  style: getSubheadingStyleBlue(),
                ),
                Divider(
                  indent:0,
                  endIndent:0,
                  thickness: 1,
                ),
                getGreyTextHolderContainer(child: getContentForOutcomes(outcomes: course.outcomes)),

                isCurrentCourse? getContentForCurrentCourse():SizedBox(height: 0,),
                isCompleted? getContentForCompletedCourse():SizedBox(height: 0,),
              ],
            ),
          ),


          Padding(
            padding:EdgeInsets.only(top: 0.05*heightOfScreen, bottom: 0.05*heightOfScreen),
            child: SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed:(){nextQuestion(context);},
                  child: Text(isCurrentCourse? 'Resume': 'Begin', style:  getNormalTextStyleWhite()),
                  style: blueButtonStyle,
                )),
          ),
        ],
      ),
    );
  }
}

/**
 * Function to get the outcomes of the new-course in the format that
 * we have designed
 */
getContentForOutcomes({required List<String> outcomes}) {
  List<Widget> childrenForColumn = [];

  for (String outcome in outcomes) {
    Widget w = Padding(

        padding: EdgeInsets.only(
          bottom: 0.01 * heightOfScreen,
        ),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getCircle(color: secondaryColor, size: 0.02 * widthOfScreen,),
            SizedBox(
              width: 0.03 * widthOfScreen,
            ),
            Expanded(child: Text(outcome, style: getNormalTextStyleBlue()))
          ],
        ));
    childrenForColumn.add(w);
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: childrenForColumn,
  );
}

/**
 * Method to get Container Showing two lines of text. Used for both 
 * showing the content for the last completed new-course and the progress in the
 * current new-course
 */

getNewSection({required String sectionName, required String txt1ForBox, required String txt2ForBox}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 0.03*heightOfScreen,),
      Text(
        sectionName,
        style: getSubheadingStyleBlue(),
      ),
      Divider(
        indent:0,
        endIndent:0,
        thickness: 1,
      ),
      SizedBox(height: 0.01*heightOfScreen,),

      Container(
          padding: EdgeInsets.all(widthOfScreen*0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: primaryColor,

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(txt1ForBox, style: getSubheadingStyleYellow(),),
              Text(txt2ForBox, style: getNormalTextStyleYellow(),)],
          )
      )
    ],
  );
}
getContentForCurrentCourse(){
  String progress=(((globals.activeUser!.currentCourse!.progress.length/globals.activeCourse!.numberOfQuestions)*100).round()).toString();

  return getNewSection(sectionName: 'Your progress', txt1ForBox: progress+'%', txt2ForBox: 'Completed');
      
}

getContentForCompletedCourse(){
  CompletedCourse cc=globals.activeUser!.completedCourses.firstWhere((element){return element.courseID==globals.activeCourse!.id;});

  String xpEarned=cc.experiencePointsEarned.toString();

  return getNewSection(sectionName: 'Best Attempt', txt1ForBox: xpEarned, txt2ForBox: 'EXP');
}
