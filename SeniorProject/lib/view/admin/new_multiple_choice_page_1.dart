import 'package:cyber/view/admin/new_multiple_choice_page_2.dart';
import 'package:cyber/view/useful/functions.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';
import '../useful/components.dart';
import 'package:cyber/view/useful/k_values.dart';

class MultipleChoiceDescription extends StatefulWidget {
  const MultipleChoiceDescription({Key? key}) : super(key: key);

  static final String routeName = '/multipleChoiceDescription';

  @override
  State<MultipleChoiceDescription> createState() =>
      _MultipleChoiceDescriptionState();
}

class _MultipleChoiceDescriptionState extends State<MultipleChoiceDescription> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controllerDescription;

  @override
  void initState() {
    super.initState();
    _controllerDescription = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: getBackButton(context: context),
        title: Text('Multiple Choice'),
        centerTitle: true,
        titleTextStyle: getSubheadingStyleWhite(),
        elevation: 0,
        actions: <Widget>[
          getExitButtonAdmin(context: context),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 0.22 * heightOfScreen),
                Text(
                  'Enter the question.',
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
                    decoration: inputDecorationForLongText,
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 0.29 * heightOfScreen),
                getNextButton(
                    todo: () {
                      Navigator.pushNamed(
                          context, MultipleChoiceOptions.routeName);
                    },
                    large: true),
                SizedBox(height: 0.04 * heightOfScreen),
                getCirclesProgressBar(position: 1, numberOfCircles: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
