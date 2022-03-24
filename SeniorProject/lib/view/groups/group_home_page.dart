import 'package:cyber/view/useful/components.dart';
import 'package:flutter/material.dart';

import '../util/functions.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';
import 'group_chat_page.dart';
import 'group_create_page.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({Key? key}) : super(key: key);

  static final String routeName = '/GroupHome';

  @override
  _GroupHomeState createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {

  late TextEditingController _controllerJoin;

  @override
  void initState() {
    super.initState();
    _controllerJoin = TextEditingController();
  }

  //Here we free the memory
  @override
  void dispose() {
    _controllerJoin.dispose();
    super.dispose();
  }

  /**
   * GROUP PAGE
   * Function returns a list tile for a group.
   * It requires an image path and a group name as well as a bool if there are unread notifications.
   */
  Widget _buildGroupTile({required String groupName, required String imagePath, bool notification = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/group_icon_default.png'),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        groupName,
        style: getNormalTextStyleBlue(),
      ),
      trailing: Row(
        children: [
          getNotification(notification),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: 30.0,
            ),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupName: groupName,)));
      },
    );
  }

  /**
   * GROUP PAGE
   * Function returns a list of group tiles.
   * It requires a list of image paths and a list of group names.
   * must pass context
   */
  Widget _buildGroups({required BuildContext context, List<String>? groupNames, List<String>? imagePaths}) {
    if (groupNames != null && imagePaths != null) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int i) {
          return _buildGroupTile(groupName: groupNames[i], imagePath: imagePaths[i], notification: true);
        },
        shrinkWrap: true,
        itemCount: groupNames.length,
        physics: const NeverScrollableScrollPhysics(),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are currently not in a group.',
              style: getNormalTextStyleBlue(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    print(heightOfScreen);
    print(widthOfScreen);
    var padding = MediaQuery.of(context).padding;
    //I update the height by subtracting the status bar height
    heightOfScreen = heightOfScreen - padding.top;

    double bannerHeight = (heightOfScreen * 211.0) / 844.0;

    List<String> imagePaths = ['assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png'];
    List<String> groupNames = ['Canes', 'Los_Yankis', 'ECE Course', 'Team', 'Alvarito', 'Chupacabra'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Image.asset(
                'assets/images/group_home_banner.png',
                width: widthOfScreen,
              ),
            ),
            getTitleAndDivider('Groups'),
            _buildGroups(context: context, imagePaths: imagePaths, groupNames: groupNames,),
            getTitleAndDivider('Join'),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: TextFormField(
                controller: _controllerJoin,
                validator: validatorForEmptyTextField,
                decoration: getInputDecoration(
                  hintText: 'Join with Group Code',
                  icon: const Icon(
                    Icons.group,
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
              child: SizedBox(
                  height: getHeightOfLargeButton(),
                  width: getWidthOfLargeButton(),
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: Text('Join Group', style: getNormalTextStyleWhite()),
                    style: blueButtonStyle,
                  )),
            ),
            getTitleAndDivider('Create'),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: getHeightOfLargeButton(),
                width: getWidthOfLargeButton(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup()));
                  },
                  child: Text('Create a Group', style: getNormalTextStyleWhite(),),
                  style: blueButtonStyle,
                ),
              ),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }
}
