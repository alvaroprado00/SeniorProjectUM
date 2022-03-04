import 'package:cyber/controller/course_controller.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  static const routeName='/category';

  @override
  Widget build(BuildContext context) {

    //final categoryName = ModalRoute.of(context)!.settings.arguments as String ;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media',
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding:EdgeInsets.only(left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
        child: SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.03*heightOfScreen,),
              getGreyTextHolderContainer(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getDoubleLineText(txt1: '10', txt2: 'Courses'),
                  SizedBox(height: 0.07*heightOfScreen,child: VerticalDivider(color:secondaryColor,thickness: 2,)),
                  getDoubleLineText(txt1: '2', txt2: 'Completed'),
                  SizedBox(height: 0.07*heightOfScreen,child: VerticalDivider(color:secondaryColor,thickness: 2,)),
                  getDoubleLineText(txt1: '2000', txt2: 'XP'),
                ],

              )),
              SizedBox(height: 0.03*heightOfScreen,),

              CourseCards(categoryName:'Info',)

            ],
          ),
        ),
      ),
    );
  }
}

getDoubleLineText({required String txt1, required String txt2}) {
  return Container(
    width: 0.27*widthOfScreen,
    child: Column(
      children: [
        Text(
          txt1,
          style: getNormalTextStyleBlue(),
        ),
        Text(
          txt2,
          style: getNormalTextStyleBlue(),
        ),
      ],
    ),
  );
}

class CourseCards extends StatefulWidget {
  const CourseCards({required String this.categoryName});

  final String categoryName;

  @override
  _CourseCardsState createState() => _CourseCardsState();
}

class _CourseCardsState extends State<CourseCards> {
  @override
  Widget build(BuildContext context) {
    final courseController=CourseController();

    return FutureBuilder(
      future: courseController.getCourseNamesFromCategory( nameOfCategory: widget.categoryName,),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.hasData) {

          if(snapshot.data.isEmpty){
            return Center(child:Text('No courses in ${widget.categoryName}'));
          }else{
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:getCourseCards(courses:snapshot.data),);
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: getHeadingStyleBlue(),),
          );
        }else{
          return Center(child: CircularProgressIndicator(color: secondaryColor,));
        }
      },
    );
  }
}

getCourseCards({required List<String> courses}){

  List<Widget> children=[];
  List<Widget> childrenForRow=[];
  int i=0;
  for (String course in courses){
    childrenForRow.add(getCardForUnsavedCourse(nameOfCourse: course, widthOfCard: 0.43*widthOfScreen, heightOfCard: 0.12*heightOfScreen));
    if(i==0){
      i++;
    }else{
      //Second Card added to the row
      children.add(Row(children: childrenForRow, mainAxisAlignment: MainAxisAlignment.spaceBetween,));
      childrenForRow=[];
      i=0;
    }
  }
  //This means that the number of courses is odd so a course has been not added
  if(courses.length%2!=0){
    children.add(Row(children: childrenForRow, mainAxisAlignment: MainAxisAlignment.spaceBetween,));
  }

  return children;

}

List<String> fakeCourses=['Passwords', 'Cookies', 'Accounts', 'CyberBullying', 'Web', 'Alvaro', 'Beltran', 'Dummy2', 'Dummy3', 'Dummy4'];