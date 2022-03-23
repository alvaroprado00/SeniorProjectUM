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
  InfoTriple info1 = InfoTriple(topLine: "120", bottomLine: "Badges");
  InfoTriple info2 = InfoTriple(topLine: "230", bottomLine: "Points");
  InfoTriple info3 = InfoTriple(topLine: "25", bottomLine: "Avatars");

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
            threeSectionMenu(info1: info1, info2: info2, info3: info3),
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
