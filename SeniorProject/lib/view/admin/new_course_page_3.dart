import 'package:cyber/view/admin/new_question_page.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';

class NewCourseDescriptionPage extends StatefulWidget {
  const NewCourseDescriptionPage({Key? key}) : super(key: key);

  static final String routeName='/newCourseDescription';

  @override
  State<NewCourseDescriptionPage> createState() => _NewCourseDescriptionPageState();
}

class _NewCourseDescriptionPageState extends State<NewCourseDescriptionPage> {

  final _formKey = GlobalKey<FormState>();
  late final _controllerDescription;

  @override
  void initState() {
    super.initState();
    _controllerDescription=TextEditingController();

  }

  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Form(
            key: _formKey,

            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getBackButton(
                        context: context),
                    Text('Description',style: getSubheadingStyleWhite()),
                    getExitButtonAdmin(context: context),

                  ],
                ),

                SizedBox( height:0.2*heightOfScreen),
                Text('Enter a course description.', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),


                Padding(
                  padding: EdgeInsets.only( top: 0.025*heightOfScreen, left: 0.03*widthOfScreen, right: 0.03*widthOfScreen),
                  child: TextFormField(
                    validator: validatorForEmptyTextField,
                    controller: _controllerDescription,
                    maxLines: 10,
                    decoration: inputDecorationForLongText,
                  ),
                ),

                SizedBox(height: 0.16*heightOfScreen,),

                getNextButton(todo:(){Navigator.pushNamed(context, NewQuestionPage.routeName);} ,large: true),
                SizedBox( height:0.04*heightOfScreen),
                getCirclesProgressBar(position: 3, numberOfCircles: 3),

              ],
            )

        ),
      ),
    );
  }
}
