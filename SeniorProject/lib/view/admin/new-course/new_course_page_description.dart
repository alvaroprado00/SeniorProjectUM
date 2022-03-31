import 'package:cyber/globals.dart' as globals;
import 'package:cyber/view/admin/new-course/new_question_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/functions.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../../model/course.dart';

class NewCourseDescriptionPage extends StatelessWidget {
  const NewCourseDescriptionPage({Key? key}) : super(key: key);

  static final String routeName = '/newCourseDescription';

  @override
  Widget build(BuildContext context) {
    //I get the new-course to add final fields
    final newCourse = ModalRoute.of(context)!.settings.arguments as Course;

    return Scaffold(
        appBar: AppBar(
          leading: (getBackButton(context: context)),
          title: Text('Description', style: getSubheadingStyleWhite()),
          centerTitle: true,
          elevation: 0,
          actions: [getExitButtonAdmin(context: context)],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(child: DescriptionForm(course: newCourse)));
  }
}

class DescriptionForm extends StatefulWidget {
  const DescriptionForm({required Course this.course});

  final Course course;
  @override
  State<DescriptionForm> createState() => _DescriptionFormState();
}

class _DescriptionFormState extends State<DescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  late final _controllerDescription;
  late final _controllerBadge;
  late final _controllerOrder;

  @override
  void initState() {
    super.initState();
    _controllerDescription = TextEditingController();
    _controllerBadge = TextEditingController();
    _controllerOrder = TextEditingController();
  }

  @override
  void dispose() {
    _controllerDescription.dispose();
    _controllerBadge.dispose();
    _controllerOrder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //I define the function to execute

    void Function() setFinalFields = () {
      if (_formKey.currentState!.validate()) {
        widget.course.description = _controllerDescription.text;
        widget.course.badgeIcon = _controllerBadge.text;
        widget.course.positionInCategory = int.parse(_controllerOrder.text);

        // I have to set the global variable to 1

        globals.newQuestionNum = 1;

        //Instead of passing the formed new-course to the next page
        //I will create a global variable since
        //the page NewQuestionPage is going to be receiving
        //questions as arguments

        globals.newCourse = widget.course;
        Navigator.pushNamed(
          context,
          NewQuestionPage.routeName,
        );
      }
    };

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.05 * heightOfScreen),
          Text(
            'Enter a course description.',
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
              controller: _controllerDescription,
              maxLines: 7,
              decoration: inputDecorationForLongText,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Spacer(),
          Text(
            'Enter the badge.',
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
              controller: _controllerBadge,
              decoration: getInputDecoration(
                hintText: 'Font-Awesome Icon Name',
                icon: Icon(
                  Icons.photo,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
          Spacer(),
          Text(
            'Enter position in category.',
            style: getNormalTextStyleWhite(),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.025 * heightOfScreen,
                left: 0.03 * widthOfScreen,
                right: 0.03 * widthOfScreen),
            child: TextFormField(
              validator: validatorForPositiveNumber,
              keyboardType: TextInputType.number,
              controller: _controllerOrder,
              decoration: getInputDecoration(
                  hintText: 'Order',
                  icon: Icon(
                    Icons.list,
                    color: secondaryColor,
                  )),
            ),
          ),
          Spacer(),
          getNextButton(todo: setFinalFields, large: true),
          SizedBox(height: 0.04 * heightOfScreen),
          getCirclesProgressBar(position: 3, numberOfCircles: 3),
          SizedBox(height: 0.01 * heightOfScreen),
        ],
      ),
    );
  }
}
