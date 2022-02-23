import 'package:cyber/view/admin/new_fill_blanks_page_1.dart';
import 'package:cyber/view/admin/new_multiple_choice_page_1.dart';
import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:cyber/view/useful/k_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewQuestionPage extends StatelessWidget {
  const NewQuestionPage({Key? key}) : super(key: key);
  static final String routeName = '/newQuestion';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Align(
              child: getExitButtonAdmin(context: context),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 0.22*heightOfScreen,),

            Text(
              'Choose a question to add.',
              style: getSubheadingStyleWhite(),
            ),

            SizedBox(height: 0.1*heightOfScreen,),

            SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MultipleChoiceDescription.routeName);
                  },
                  child: Text('Multiple Choice', style:  getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),

            SizedBox(height: 0.05*heightOfScreen,),
            SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, FillInBlanksText.routeName);
                  },
                  child: Text('Fill In the blanks', style:  getNormalTextStyleBlue()),
                  style: yellowButtonStyle,
                )),

            SizedBox(height: 0.2*heightOfScreen,),
            SizedBox(
                height: getHeightOfSmallButton(),
                width: getWidthOfSmallButton(),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Submit Course', style:  getNormalTextStyleBlue()),
                  style: greyButtonStyle,
                )),
          ],
        ),
      ),


    );
  }


}


