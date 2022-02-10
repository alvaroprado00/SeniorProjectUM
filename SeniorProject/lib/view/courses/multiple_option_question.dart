import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';


class MultOptQuestion extends StatelessWidget {
const MultOptQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [Text('1 of 10', style: getNormalTextStyleWhite(),),
               getOptionsButton(context: context, courseTitle: 'Passwords', categoryTitle: 'Social Media', question: 2, numberOfQuestions: 10)
              ],
            )
          ],
        )

      ),
    );
  }
}
