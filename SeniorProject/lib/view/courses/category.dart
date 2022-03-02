

import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';


class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media', style: getSubheadingStyleBlue(),),
        leading: getBackButton(context: context),

      ),
    );
  }
}
