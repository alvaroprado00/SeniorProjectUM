import 'package:cyber/view/useful/components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/user_custom.dart';
import '../useful/k_colors.dart';
import '../useful/k_styles.dart';

class AllAvatarsPage extends StatefulWidget {
  const AllAvatarsPage({Key? key, required this.dummyUser}) : super(key: key);
  final UserCustom dummyUser;

  @override
  _AllAvatarsPageState createState() => _AllAvatarsPageState();
}

class _AllAvatarsPageState extends State<AllAvatarsPage> {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.center),
            threeSectionMenu(info1: info1, info2: info2, info3: info3),
            Padding(padding: EdgeInsets.all(10)),
            SubtitleDivider(subtitle: "Collected"),
          ],
        )),
      ),
    );
  }
}
