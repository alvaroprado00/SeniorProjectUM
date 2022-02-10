/**
 * This page builds a course description page for an specific course
 * Now I get the course form a method in the model package. In the future
 * the name of the course should be provided when calling the constructor
 * so we can build the course by calling the database for that specific course
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/model/course.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

class CourseDescription extends StatelessWidget {

  const CourseDescription({required String this.courseTitle});

  final String courseTitle;
  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;

    //I update the height by subtracting the status bar height
    heightOfScreen = heightOfScreen - padding.top;
    final courseController=CourseController();

    return Scaffold(
      backgroundColor: tertiaryColor,
      body:FutureBuilder(
        future: courseController.getCourse(title: courseTitle),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {
              return CourseDescriptionContent(course: snapshot.data.data());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: getHeadingStyleWhite(),),
            );
          }else{
            return CircularProgressIndicator();
          }
        },
      )
    );
  }
}


class CourseDescriptionContent extends StatelessWidget {

  const CourseDescriptionContent({required Course this.course});
  final Course course;
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
                      SaveButton()
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
                Container(
                  padding: EdgeInsets.all(widthOfScreen*0.02),
                  decoration: new BoxDecoration(

                      color: quinaryColor,
                      borderRadius: new BorderRadius.all(
                        Radius.circular(0.05 * widthOfScreen),
                      )),
                  child: getContentForOutcomes(outcomes: course.outcomes),
                ),
              ],
            ),
          ),


          Padding(
            padding:EdgeInsets.only(top: 0.05*heightOfScreen, bottom: 0.05*heightOfScreen),
            child: SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: () {
                    print('popo');
                  },
                  child: Text('Begin', style:  getNormalTextStyleWhite()),
                  style: largeBlueButtonStyle,
                )),
          ),
        ],
      ),
    );
  }
}

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
            getCircle(color: secondaryColor),
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