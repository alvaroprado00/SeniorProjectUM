import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber/view/groups/group_info_page.dart';
import 'package:flutter/material.dart';
import '../../model/group.dart';
import '../util/cards.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.snapshot}) : super(key: key);

  final Group snapshot;
  static final String routeName = "/ChatPage";

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

  Widget _buildNotifications({required BuildContext context,}) {

    return Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int i) {
              return getCardForNotification(
                  username: widget.snapshot.groupNotifications[i].userName.toString(),
                  widthOfCard: getWidthOfLargeButton(),
                  nameOfCourse: widget.snapshot.groupNotifications[i].message.toString(),
                  heightOfCard: heightOfScreen * 0.12,
              );
            },
            shrinkWrap: true,
            itemCount: widget.snapshot.groupNotifications.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {

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
                  child: Image.network(
                    widget.snapshot.groupImageURL,
                    fit: BoxFit.fitWidth,
                  ),
                  width: widthOfScreen,
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
                    widget.snapshot.groupName.toString(),
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 27,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfoPage(groupName: "Group Name", usernames: usernames)));
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
            _buildNotifications(context: context),
          ],
        ),
      ),
    );
  }
}
