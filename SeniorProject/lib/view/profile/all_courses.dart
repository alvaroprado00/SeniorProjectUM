import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/user_custom.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';

class AllCoursePage extends StatefulWidget {
  const AllCoursePage({Key? key, required this.dummyUser}) : super(key: key);
  final UserCustom dummyUser;

  @override
  _AllCoursePageState createState() => _AllCoursePageState();
}

class _AllCoursePageState extends State<AllCoursePage> {

  FaIcon getIcon(String icon) {
    return FaIcon(FontAwesomeIcons.car);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Courses",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.center),
            ProgressContainerThreeFields(field1: '120 Badges', field2:'230 Points' , field3: '25 Avatars'),
            SubtitleDivider(subtitle: "Social Media"),
            SubtitleDivider(subtitle: "Information"),
            SubtitleDivider(subtitle: "Devices"),
            SubtitleDivider(subtitle: "Web")
          ],
        )),
      ),
    );
  }
}
