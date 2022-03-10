import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/globals.dart' as globals;
import 'package:cyber/model/course.dart';
import 'package:cyber/view/courses/category.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

import '../useful/cards.dart';



class CourseDescription extends StatelessWidget {

  const CourseDescription({Key? key}) : super(key: key);

  static final routeName='/courseDescription';

  @override
  Widget build(BuildContext context) {

    final String courseID = ModalRoute.of(context)!.settings.arguments as String;


    //I need to have an instance of the Course controller to use the methods
    //defined in that class
    final courseController=CourseController();

    // Before building the page I need to get the course from the DB
    return Scaffold(
      backgroundColor: tertiaryColor,
      body:FutureBuilder(
        future: courseController.getCourseByID(id: courseID),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {

              //Once I get the course I assign its value to a global variable
              // so I can access the info from other pages easily
              globals.activeCourse=snapshot.data;
              globals.activeQuestionNum=1;
              globals.userProgress=[];

              //I check if the activeUser has the courseSaved or if its the current one
              bool isSaved=false;
              bool isCurrentCourse=false;

              if(globals.activeUser!.coursesSaved.contains(courseID)){
                isSaved=true;
              }
              if(globals.activeUser!.currentCourse!=null && globals.activeUser!.currentCourse!.courseID==courseID){
                isCurrentCourse=true;
                globals.activeQuestionNum=globals.activeUser!.currentCourse!.progress.length+1;
                globals.userProgress=globals.activeUser!.currentCourse!.progress;

              }
              return CourseDescriptionContent(course: snapshot.data, isSaved: isSaved, isCurrentCourse: isCurrentCourse);
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
 * This class is built specifying a course in its constructor.
 * When built, it shows the info from the course
 */
class CourseDescriptionContent extends StatelessWidget {

  const CourseDescriptionContent({required Course this.course, required bool this.isSaved, required this.isCurrentCourse});
  final Course course;
  final bool isSaved;
  final bool isCurrentCourse;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.title,
                        style: getHeadingStyleBlue(),
                      ),
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
                SizedBox(height: 0.03*heightOfScreen,),
                isCurrentCourse? getContentForCurrentCourse():SizedBox(height: 0,),
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
 * Function to get the outcomes of the course in the format that
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

getContentForCurrentCourse(){

  final double progress;

  progress=globals.activeUser!.currentCourse!.progress.length.toDouble()/globals.activeCourse!.numberOfQuestions.toDouble();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Your progress',
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
          children: [Text('${progress}%', style: getSubheadingStyleYellow(),),
          Text('Completed', style: getNormalTextStyleYellow(),)],
        )
      )
    ],
  );
}

