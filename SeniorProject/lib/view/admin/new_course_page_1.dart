import 'package:cyber/model/course.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart' as k_values;

import 'new_course_page_2.dart';

class NewCoursePage extends StatefulWidget {
  const NewCoursePage({Key? key}) : super(key: key);

  static final String routeName='/newCourse';

  @override
  State<NewCoursePage> createState() => _NewCoursePageState();
}

class _NewCoursePageState extends State<NewCoursePage> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerTitle;
  late TextEditingController _controllerImage;
  late TextEditingController _controllerXP;

  // The following list is used for the dropdown button
  static final List<k_values.Category> items =[
    k_values.Category.socialMedia,
    k_values.Category.info,
    k_values.Category.devices,
    k_values.Category.web,
  ];

  //Default option in the dropdown button
  k_values.Category value=items.first;

  //Initialization of text form field controllers
  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController();
    _controllerImage = TextEditingController();
    _controllerXP = TextEditingController();

  }

  //Free memory
  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerImage.dispose();
    _controllerXP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //I define the function to be used when submitting the form
    void Function() updateCourseFields=(){

      //Returns true if the form is valid
      if (_formKey.currentState!.validate()) {

        //I create a course with dummy values

        Course newCourse=Course(imageURL: '', title: '', category: k_values.Category.info, positionInCategory: 1, numberOfQuestions:1 , experiencePoints:1, description: '',badgeIcon:'', outcomes: [], questions:[]);

        //I update the fields
        newCourse.title=_controllerTitle.text;
        newCourse.experiencePoints=int.parse(_controllerXP.text);
        newCourse.category=value;
        newCourse.imageURL=_controllerImage.text;

        Navigator.pushNamed(context, NewCourseOutcomesPage.routeName, arguments: newCourse);
      }
    };

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: getBackButton(context: context),
        title:Text('New Course', style: getSubheadingStyleWhite(),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        //This widget solves the problem of the overflow caused by the keyboard
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('Title.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),

                Padding(
                  padding: EdgeInsets.only( top: 0.025*k_values.heightOfScreen, left: 0.03*k_values.widthOfScreen, right: 0.03*k_values.widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerTitle,
                    decoration: getInputDecoration(
                        hintText: 'Title',
                        icon: Icon(
                          Icons.format_italic,
                          color: secondaryColor,
                        )),
                  ),
                ),

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('Category.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),
                SizedBox( height:0.025*k_values.heightOfScreen),
                buildDropdown(),

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('Image.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),

                Padding(
                  padding: EdgeInsets.only( top: 0.025*k_values.heightOfScreen, left: 0.03*k_values.widthOfScreen, right: 0.03*k_values.widthOfScreen),
                  child: TextFormField(
                    validator: validatorForURL,
                    controller: _controllerImage,
                    decoration: getInputDecoration(
                        hintText: 'Enter valid URL',
                        icon: Icon(
                          Icons.photo,
                          color: secondaryColor,
                        )),
                  ),
                ),

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('XP.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),

                Padding(
                  padding: EdgeInsets.only( top: 0.025*k_values.heightOfScreen, left: 0.35*k_values.widthOfScreen, right: 0.35*k_values.widthOfScreen),
                  child: TextFormField(
                    validator: validatorForExp,
                    keyboardType: TextInputType.number,
                    controller: _controllerXP,
                    decoration: getInputDecoration(
                        hintText: 'XP',
                        icon: Icon(
                          Icons.star,
                          color: secondaryColor,
                        )),
                  ),
                ),

                SizedBox( height:0.055*k_values.heightOfScreen),



                getNextButton(todo:updateCourseFields, large: true),
                SizedBox( height:0.04*k_values.heightOfScreen),

                getCirclesProgressBar(position: 1, numberOfCircles: 3),
                SizedBox(height: 0.01 * heightOfScreen),

              ],
            ),
          )
          ,
        ),
      ),
    );
  }



Widget buildDropdown() => Container(
  width: 0.94*k_values.widthOfScreen,
  padding: EdgeInsets.symmetric(horizontal: 0.1*k_values.widthOfScreen, vertical: 0.005*k_values.heightOfScreen),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Colors.white,
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButtonFormField(
      decoration: InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
      value: value, // currently selected item
      items: items
          .map((item) => DropdownMenuItem<k_values.Category>(
        child: Text(
          k_values.categoryToString[item]?? 'No category',
          style: getNormalTextStyleBlue(),
        ),
        value: item,
      ))
          .toList(),
      onChanged: (value) => setState(() {
        this.value =value as k_values.Category;
      }),
    ),
  ),
);
}

