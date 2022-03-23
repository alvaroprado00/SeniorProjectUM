import 'package:cyber/config/fixed_values.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:cyber/view/courses/overview_dialog.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'category_progress.dart';

class Overview extends StatelessWidget {

  const Overview({Key? key}) : super(key: key);

  static final  String routeName='/overview';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Overview',
            style: getSubheadingStyleBlue(),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: tertiaryColor,
        ),
        backgroundColor: tertiaryColor,
        body: FutureBuilder(
          future: activeUser!.saveCompletedCourse(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              return ContentForOverview(earnedBadge:snapshot.data.earnedBadge, levelUp: snapshot.data.levelUp, balanceXP: snapshot.data.balanceXP,);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: getHeadingStyleBlue(),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));


  }
}
class ContentForOverview extends StatefulWidget {
  const ContentForOverview({required bool this.earnedBadge, required bool this.levelUp, required int this.balanceXP});

  final bool earnedBadge;
  final bool levelUp;
  final int balanceXP;

  @override
  _ContentForOverviewState createState() => _ContentForOverviewState();
}

class _ContentForOverviewState extends State<ContentForOverview> {

  //All of these params are used to display the info. We are going to
  //initialize them after updating the user in the DB
  final String xpInLevel=activeUser!.level.xpInLevel.toString();
  final String level=activeUser!.level.levelNumber.toString();
  final String questionsRight=activeUser!.completedCourses.last.numQuestionsRight.toString();
  final List<bool> answers=activeUser!.completedCourses.last.answers;
  final String numQuestions=activeUser!.completedCourses.last.answers.length.toString();
  final String xpEarned=activeUser!.completedCourses.last.experiencePointsEarned.toString();

  @override
  void initState() {

    super.initState();


    SchedulerBinding.instance!.addPostFrameCallback((_) {

      //After the widget builds we check if the user has leveled up to show
      //the alert dialog corresponding to that

      if(widget.levelUp){
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return OverviewDialog(isBadge: false,);
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: 0.05 * widthOfScreen, right: 0.05 * widthOfScreen),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              getCircularProgressCustom(xp: xpInLevel, level:level),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              Text(
                'Level $level',
                style: getSubheadingStyleBlue(),
              ),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '$questionsRight/$numQuestions',
                    style: getHeadingStyleBlue(),
                  ),
                  Text(
                    '+ ${widget.balanceXP.toString()} EXP',
                    style: getHeadingStyleBlue(),
                  ),
                ],
              ),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              getCirclesProgressBarForCourseProgression(
                  answers: answers, numberOfCircles: answers.length),
              SizedBox(
                height: heightOfScreen * 0.05,
              ),
              widget.earnedBadge
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You earned a new badge.',
                    style: getNormalTextStyleBlue(),
                  ),
                  SizedBox(height: 0.025*heightOfScreen,),
                  getSeeBadgeButton(context: context),
                  SizedBox(height: 0.025*heightOfScreen,),

                ],
              )
                  : SizedBox(
                height: 0.1 * heightOfScreen,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getRestartButton(context: context),
                  getNextButton(todo:(){Navigator.pushNamed(context, CategoryProgress.routeName);}, large: false),
                ],
              )
            ]),
      ),
    );


  }
}




//The following three methods are used to get widgets for the content of the page
//and make it easier to read


getRestartButton({required BuildContext context}){
  return SizedBox(
      height: getHeightOfSmallButton(),
      width: getWidthOfSmallButton(),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, CourseDescription.routeName, arguments: activeCourse!.id);
        },
        child: Text('Restart', style: getNormalTextStyleBlue()),
        style: yellowButtonStyle,
      ));
}
getSeeBadgeButton({required BuildContext context}) {
  return SizedBox(
      height: getHeightOfLargeButton(),
      width: getWidthOfLargeButton(),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return OverviewDialog(isBadge: true,);
              });
        },
        child: Text('See Badge', style: getNormalTextStyleBlue()),
        style: greyButtonStyle,
      ));
}


getCircularProgressCustom({required String xp, required String level}) {
  return SizedBox(
    height: 0.27 * heightOfScreen,
    child: Stack(
      children: <Widget>[
        Center(
          child: Container(
            width: 0.5 * widthOfScreen,
            height: 0.27 * heightOfScreen,
            child: CircularProgressIndicator(
              strokeWidth: 25,
              value: double.parse(xp)/(double.parse(level)*levelScale+baseLevel),
              color: secondaryColor,
            ),
          ),
        ),
        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  xp,
                  style: TextStyle(
                      fontFamily: 'roboto',
                      color: primaryColor,
                      fontSize: 0.1 * widthOfScreen,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'EXP',
                  style: getNormalTextStyleBlue(),
                )
              ],
            )),
      ],
    ),
  );
}

