import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/foundation.dart';
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

  static final List<k_values.Category> items =[
    k_values.Category.socialMedia,
    k_values.Category.info,
    k_values.Category.devices,
    k_values.Category.web,
  ];

  k_values.Category value=items.first;

  //When the widget is created we initialize the text form fields controllers
  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController();
    _controllerImage = TextEditingController();
    _controllerXP = TextEditingController();

  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerImage.dispose();
    _controllerXP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        //This is to solve the problem of the overflow caused by the keyboard
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getBackButton(
                      context: context),
                    SizedBox(width: 0.22*k_values.widthOfScreen,),
                    Text('New Course',style: getSubheadingStyleWhite()),

                  ],
                ),

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('Enter a Title.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),


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
                Text('Enter a Category.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),
                SizedBox( height:0.025*k_values.heightOfScreen),
                buildDropdown(),

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('Enter an image.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),

                Padding(
                  padding: EdgeInsets.only( top: 0.025*k_values.heightOfScreen, left: 0.03*k_values.widthOfScreen, right: 0.03*k_values.widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerImage,
                    decoration: getInputDecoration(
                        hintText: 'Image URL',
                        icon: Icon(
                          Icons.photo,
                          color: secondaryColor,
                        )),
                  ),
                ),

                SizedBox( height:0.05*k_values.heightOfScreen),
                Text('Enter XP.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),

                Padding(
                  padding: EdgeInsets.only( top: 0.025*k_values.heightOfScreen, left: 0.35*k_values.widthOfScreen, right: 0.35*k_values.widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
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

                getNextButton(todo:(){Navigator.pushNamed(context, NewCourseOutcomesPage.routeName);}, large: true),
                SizedBox( height:0.04*k_values.heightOfScreen),

                getCirclesProgressBar(position: 1, numberOfCircles: 3),






              ],
            )
            ,
          ),

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
          k_values.stringFromCategory[item]?? 'No category',
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