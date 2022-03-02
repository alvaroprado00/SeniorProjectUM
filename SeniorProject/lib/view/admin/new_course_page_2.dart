import 'package:cyber/model/course.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

import 'new_course_page_3.dart';

class NewCourseOutcomesPage extends StatefulWidget {
  const NewCourseOutcomesPage({Key? key}) : super(key: key);

  static final String routeName = '/newCourseOutcomes';

  @override
  State<NewCourseOutcomesPage> createState() => _NewCourseOutcomesPageState();
}

class _NewCourseOutcomesPageState extends State<NewCourseOutcomesPage> {
  final _formKey = GlobalKey<FormState>();
  late final _controllerOutcome;
  int _outcomeNumber = 1;

  @override
  void initState() {
    super.initState();
    _controllerOutcome = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerOutcome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // I get the Course half filled in the previous page

    final newCourse = ModalRoute.of(context)!.settings.arguments as Course;
    final SnackBar snBar = SnackBar(
      content: Text(
        'Outcome $_outcomeNumber added',
        style: getNormalTextStyleBlue(),
      ),
      backgroundColor: secondaryColor,
    );

    //I define the function that is going to be used with the button add

    void Function() addOutcomeToCourse = () {
      //Returns true if the form is valid
      if (_formKey.currentState!.validate()) {
        newCourse.outcomes.add(_controllerOutcome.text);

        //Give feedback to user

        ScaffoldMessenger.of(context).showSnackBar(snBar);

        //Update state variable

        setState(() {
          _outcomeNumber++;
        });

        //And also clear the field
        _controllerOutcome.clear();
      }
    };

    void Function() nextPage = () {
      //We have to check some outcome has been added

      if (newCourse.outcomes.isEmpty) {
        SnackBar snBar = SnackBar(
          content: Text(
            'You need to add at least one outcome',
            style: getNormalTextStyleBlue(),
          ),
          backgroundColor: secondaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snBar);
      } else {
        //Once all the outcomes have been added to the course we navigate to the
        //next page
        Navigator.pushNamed(context, NewCourseDescriptionPage.routeName,
            arguments: newCourse);
      }
    };

    return Scaffold(
      appBar: AppBar(
        leading: getBackButton(context: context),
        title: Text('Outcomes', style: getSubheadingStyleWhite()),
        centerTitle: true,
        elevation: 0,
        actions: [getExitButtonAdmin(context: context)],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 0.25 * heightOfScreen),
                  Text(
                    'Outcome ${_outcomeNumber}',
                    style: getNormalTextStyleWhite(),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.025 * heightOfScreen,
                        left: 0.03 * widthOfScreen,
                        right: 0.03 * widthOfScreen),
                    child: TextFormField(
                      validator: validatorForEmptyTextField,
                      controller: _controllerOutcome,
                      maxLines: 3,
                      decoration: inputDecorationForLongText,
                    ),
                  ),
                  SizedBox(
                    height: 0.3 * heightOfScreen,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          height: getHeightOfSmallButton(),
                          width: getWidthOfSmallButton(),
                          child: ElevatedButton(
                            onPressed: addOutcomeToCourse,
                            child: Text('Add', style: getNormalTextStyleBlue()),
                            style: yellowButtonStyle,
                          )),
                      getNextButton(todo: nextPage, large: false)
                    ],
                  ),
                  SizedBox(height: 0.04 * heightOfScreen),
                  getCirclesProgressBar(position: 2, numberOfCircles: 3),
                  SizedBox(height: 0.01 * heightOfScreen),
                ],
              ),
            )),
      ),
    );
  }
}
