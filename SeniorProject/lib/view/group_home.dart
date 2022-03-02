import 'package:cyber/view/k_colors.dart';
import 'package:flutter/material.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({Key? key, bool groupData = false, }) : super(key: key);

  @override
  _GroupHomeState createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {

  Widget groupCard({required String imagePath, required String groupName}) {
    return Container(
      height: 60.0,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 25.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(imagePath),
                    maxRadius: 25.0,
                  ),
                ),
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios),
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget groupsList({List<String>? imagePaths, List<String>? groupNames}) {
    if (groupNames != null && imagePaths != null) {
      return Container (
        child: ListView.builder(
            itemCount: groupNames.length,
            itemBuilder: (BuildContext context,int index){
              return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (NetworkImage(imagePaths[index])),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chevron_right),
                    color: primaryColor,
                  ),
                  title:Text(groupNames[index]),
              );
            }
        ),
      );
    }
    else {
      return Container(
        padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are currently not in a group.',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: primaryColor,
              ),
            ),
            Text(
              'Group chats will apear here once you join a group.',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double bannerHeight = (screenHeight * 211.0) / 844;
    double contentHeight = (screenHeight * 538.0) / 844;

    double maxWidth = (screenWidth * 358.0) / 390;
    double dividerIndent = (screenWidth - maxWidth) / 2;

    List<String> groupNames = ['Los_Yankis', 'ECE 579', 'Chupacabra'];
    List<String> imagePaths = ['assets/images/default_group_logo.png', 'assets/images/default_group_logo.png', 'assets/images/default_group_logo.png'];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: bannerHeight,
            width: screenWidth,
            child: Image.asset(
              'assets/images/group_home_banner.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0, top: 12.0),
                    child: Text(
                      'Groups',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
                indent: dividerIndent,
                endIndent: dividerIndent,
              ),
              groupsList(groupNames: groupNames,),
            ],
          ),
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0, top: 12.0),
                      child: Text(
                        'Join',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                  indent: dividerIndent,
                  endIndent: dividerIndent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
