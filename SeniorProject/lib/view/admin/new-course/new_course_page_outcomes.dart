import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../../model/course.dart';
import 'new_course_page_description.dart';

class NewCourseOutcomesPage extends StatelessWidget {
  const NewCourseOutcomesPage({Key? key}) : super(key: key);
  static final String routeName = '/newCourseOutcomes';

  @override
  Widget build(BuildContext context) {
    final newCourse = ModalRoute.of(context)!.settings.arguments as Course;
    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: getBackButton(context: context),
            title: Text('Outcomes', style: getSubheadingStyleWhite()),
            centerTitle: true,
            elevation: 0,
            actions: [getExitButtonAdmin(context: context)],
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(child: OutcomesForm(course: newCourse))),
    );
  }
}

class OutcomesForm extends StatefulWidget {
  const OutcomesForm({required Course this.course});
  final Course course;

  @override
  State<OutcomesForm> createState() => _OutcomesFormState();
}

class _OutcomesFormState extends State<OutcomesForm> {
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
    //I define the function that is going to be used with the button add

    void Function() addOutcomeToCourse = () {
      String message = '';
      //Returns true if the form is valid
      if (_formKey.currentState!.validate()) {
        if (_outcomeNumber < 4) {
          widget.course.outcomes.add(_controllerOutcome.text.trim());

          //Update state variable
          message = 'Outcome added';
          setState(() {
            _outcomeNumber++;
          });
        } else {
          message = 'No more outcomes allowed';
        }

        final SnackBar snBar = SnackBar(
          content: Text(
            message,
            style: getNormalTextStyleBlue(),
          ),
          backgroundColor: secondaryColor,
        );

        //And also clear the field
        _controllerOutcome.clear();
        //Give feedback to user
        ScaffoldMessenger.of(context).showSnackBar(snBar);
      }
    };

    void Function() nextPage = () {
      //We have to check some outcome has been added

      if (widget.course.outcomes.isEmpty) {
        SnackBar snBar = SnackBar(
          content: Text(
            'You need to add at least one outcome.',
            style: getNormalTextStyleBlue(),
          ),
          backgroundColor: secondaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snBar);
      } else {
        //Once all the outcomes have been added to the new-course we navigate to the
        //next page
        Navigator.pushNamed(context, NewCourseDescriptionPage.routeName,
            arguments: widget.course);
      }
    };

    return Form(
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
                height: 0.35 * heightOfScreen,
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
              getCirclesProgressBar(position: 2, numberOfCircles: 4),
              SizedBox(height: 0.01 * heightOfScreen),
            ],
          ),
        ));
  }
}
