import 'package:cyber/view/groups/group_info_page.dart';
import 'package:flutter/material.dart';

import '../useful/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.groupName}) : super(key: key);

  final String groupName;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Column getDayTitle(String day) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                day,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNotifications({required BuildContext context,
    required List<String> courseNames,
    required List<String> usernames}) {

    if (usernames != null) {
      String day = 'Today';
      return Column(
          children: [
            getDayTitle(day),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemBuilder: (BuildContext context, int i) {
                return getCardForNotification(
                    username: usernames[i],
                    widthOfCard: getWidthOfLargeButton(),
                    nameOfCourse: courseNames[i],
                    heightOfCard: heightOfScreen * 0.12,
                );
              },
              shrinkWrap: true,
              itemCount: usernames.length,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ]
      );
    }
    else {
      return const Center(
        child: Text(
          'You have no notifications at the moment.',
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double bannerHeight = (screenHeight * 211.0) / 844.0;

    List<String> courseNames = ['NFTs', 'Crypto', 'Passwords', 'Social Engineering', 'Twitter', 'Instagram'];
    List<String> usernames = ['Alvarito_007', 'Pablo22', 'elVacan', 'beltrus', 'kerryCaverga', 'Siuu'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/default_chat_banner.png',
                    fit: BoxFit.fitHeight,
                  ),
                  width: screenWidth,
                  height: bannerHeight,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: getBackButton(context: context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.groupName,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 27,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfoPage(groupName: widget.groupName, usernames: usernames)));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
                      backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                    ),
                    child: Icon(Icons.person_add),
                  ),
                ],
              ),
            ),
            _buildNotifications(
                context: context,
                usernames: usernames,
                courseNames: courseNames,
            ),
          ],
        ),
      ),
    );
  }
}
