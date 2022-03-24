import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/user_custom.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class AllAvatarsPage extends StatefulWidget {
  const AllAvatarsPage({Key? key}) : super(key: key);


  @override
  _AllAvatarsPageState createState() => _AllAvatarsPageState();
}

class _AllAvatarsPageState extends State<AllAvatarsPage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Avatars",
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.05*heightOfScreen,),
            SubtitleDivider(subtitle: 'Collected Avatars'),
            SizedBox(height: 0.05*heightOfScreen,),
            //getAvatars();


          ],
        )),
      ),
    );
  }
}


getAvatars(){

   // List<String>
}
