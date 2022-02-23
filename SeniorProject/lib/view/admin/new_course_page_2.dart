import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

import 'new_course_page_3.dart';

class NewCourseOutcomesPage extends StatefulWidget {
  const NewCourseOutcomesPage({Key? key}) : super(key: key);

  static final String routeName='/newCourseOutcomes';

  @override
  State<NewCourseOutcomesPage> createState() => _NewCourseOutcomesPageState();
}

class _NewCourseOutcomesPageState extends State<NewCourseOutcomesPage> {

  final _formKey = GlobalKey<FormState>();
  late final _controllerOutcome;
  final _outcomeNumber=0;

  @override
  void initState() {
    super.initState();
    _controllerOutcome=TextEditingController();

  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerOutcome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Form(
          key: _formKey,

        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getBackButton(
                      context: context),
                  Text('Outcomes',style: getSubheadingStyleWhite()),
                  getExitButtonAdmin(context: context),

                ],
              ),

              SizedBox( height:0.25*heightOfScreen),
              Text('Outcome ${_outcomeNumber+1}', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),


              Padding(
                padding: EdgeInsets.only( top: 0.025*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                child: TextFormField(
                  validator: validatorForEmptyTextField,
                  controller: _controllerOutcome,
                  maxLines: 3,
                  decoration: inputDecorationForLongText,
                ),
              ),

              SizedBox(height: 0.3*heightOfScreen,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      height: getHeightOfSmallButton(),
                      width: getWidthOfSmallButton(),
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        child: Text('Add', style:  getNormalTextStyleBlue()),
                        style: yellowButtonStyle,
                      )),

                  getNextButton(todo:(){Navigator.pushNamed(context, NewCourseDescriptionPage.routeName);},large: false)
                ],
              ),

              SizedBox( height:0.04*heightOfScreen),
              getCirclesProgressBar(position: 2, numberOfCircles: 3),


            ],
          ),
        )

        ),
      ),
    );
  }
}
