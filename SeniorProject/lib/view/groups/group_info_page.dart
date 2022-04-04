import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({Key? key, required this.groupName, required this.usernames}) : super(key: key);

  final String groupName;
  final List<String> usernames;
  static final String routeName = "/GroupInfo";


  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {

  Widget _buildRow({required String avatarPath, required String userLevel, required String userName}) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatarPath),
        backgroundColor: Colors.transparent,
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          userName,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          userLevel,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions({required BuildContext context, required List<String> groupMembers, required List<String> avatarPaths, required List<String> userLevels}) {
    return Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int i) {
              return _buildRow(avatarPath: avatarPaths[i],userName: groupMembers[i], userLevel: userLevels[i]);
            },
            shrinkWrap: true,
            itemCount: groupMembers.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ]
    );
  }

  Widget getGroupCode({required String groupCode}) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: groupCode)).then((_){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Group Code copied to clipboard!',
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
              ),
            ),
            backgroundColor: secondaryColor,
          )
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.lock,
              color: secondaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                groupCode,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 36,
                ),
              ),
            ),
            const Icon(
              Icons.copy,
              color: secondaryColor,
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0))),
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFD5D5D5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<String> avatarPaths = ['assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png', 'assets/images/group_icon_default.png'];
    List<String> userLevels = ['Level 1', 'Level 2', 'Level 3', 'Level 6', 'Level 1', 'Level 5'];
    // List<String> userNames = ['Alvarito_007', 'Alvarito_007', 'Alvarito_007', 'Alvarito_007', 'Alvarito_007', 'Alvarito_007'];
    String groupCode = 'XYZ123';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 23.0),
              child: Stack(
                children: [
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: getBackButton(context: context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.groupName,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildSuggestions(
              context: context,
              avatarPaths: avatarPaths,
              groupMembers: widget.usernames,
              userLevels: userLevels,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.group,
                    color: secondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 34.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.usernames.length.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const TextSpan(
                            text: ' Members',
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Group Code',
                    style: TextStyle(
                      fontSize: 22,
                      color: primaryColor,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
            getGroupCode(groupCode: groupCode),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 50.0),
              child: SizedBox(
                height: 50.0,
                width: 384.0,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Leave Group', style: getNormalTextStyleWhite(),),
                  style: blueButtonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
