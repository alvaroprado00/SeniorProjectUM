import 'package:cyber/view/admin/new-course/new_course_page_badge.dart';
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

    return GestureDetector(
      onTap: (){        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: (getBackButton(context: context)),
            title: Text('Description', style: getSubheadingStyleWhite()),
            centerTitle: true,
            elevation: 0,
            actions: [getExitButtonAdmin(context: context)],
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(child: DescriptionForm(course: newCourse))),
    );
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
  late final _controllerOrder;

  @override
  void initState() {
    super.initState();
    _controllerDescription = TextEditingController();
    _controllerOrder = TextEditingController();
  }

  @override
  void dispose() {
    _controllerDescription.dispose();
    _controllerOrder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //I define the function to execute

    void Function() setFinalFields = () {
      if (_formKey.currentState!.validate()) {
        widget.course.description = _controllerDescription.text.trim();
        widget.course.positionInCategory =
            int.parse(_controllerOrder.text.trim());

        Navigator.pushNamed(
          context,
          BadgePage.routeName,
          arguments: widget.course,
        );
      }
    };

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.1 * heightOfScreen),
            Text(
              'Course Description',
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
              ),
            ),
            SizedBox(height: 0.15 * heightOfScreen),
            Text(
              'Category Position',
              style: getNormalTextStyleWhite(),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 0.025 * heightOfScreen,
                  left: 0.3 * widthOfScreen,
                  right: 0.3 * widthOfScreen),
              child: TextFormField(
                validator: validatorForPositiveNumber,
                keyboardType: TextInputType.number,
                controller: _controllerOrder,
                decoration: getInputDecoration(
                    hintText: 'Position',
                    icon: Icon(
                      Icons.numbers,
                      color: secondaryColor,
                    )),
              ),
            ),
            SizedBox(
              height: 0.12 * heightOfScreen,
            ),
            getNextButton(todo: setFinalFields, large: true),
            SizedBox(height: 0.04 * heightOfScreen),
            getCirclesProgressBar(position: 3, numberOfCircles: 4),
            SizedBox(height: 0.01 * heightOfScreen),
          ],
        ),
      ),
    );
  }
}
