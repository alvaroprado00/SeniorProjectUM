import 'package:cyber/view/useful/components.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_styles.dart';
import 'package:flutter/material.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({Key? key}) : super(key: key);

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

  Container getNotification(bool notification) {
    if (!notification) {
      return Container(height: 5.0, width: 5.0,color: Colors.transparent,);
    }
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: secondaryColor,
      ),
    );
  }

  Widget _buildRow({required String groupName, required String imagePath, bool notification = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        groupName,
        style: const TextStyle(
          fontSize: 20,
          color: primaryColor,
          fontFamily: 'Roboto',
        ),
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

  Widget _buildSuggestions({required BuildContext context, List<String>? groupNames, List<String>? imagePaths}) {
    if (groupNames != null && imagePaths != null) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int i) {
          return _buildRow(groupName: groupNames[i], imagePath: imagePaths[i], notification: true);
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
          children: const [
            Text(
              'You are currently not in a group.',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double bannerHeight = (screenHeight * 211.0) / 844.0;

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
                width: screenWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Groups',
                    style: TextStyle(
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
            _buildSuggestions(context: context, imagePaths: imagePaths, groupNames: groupNames,),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Join',
                    style: TextStyle(
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
                    style: largeBlueButtonStyle,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Create',
                    style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: 50.0,
                width: 384.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup()));
                  },
                  child: Text('Create a Group'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                  ),
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
