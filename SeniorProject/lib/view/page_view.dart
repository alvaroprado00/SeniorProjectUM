import 'package:cyber/view/k_colors.dart';
import 'package:cyber/view/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key, required this.buildContext})
      : super(key: key);
  final BuildContext buildContext;

  static final routeName = '/PageViewScreen';
  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          ProfilePage(
            buildContext: context,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffFfffff),
        unselectedItemColor: primaryColor,
        selectedItemColor: secondaryColor,
        showUnselectedLabels: true,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 24,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: 'Courses'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.suit_diamond), label: 'Featured'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded), label: 'Groups'),
          BottomNavigationBarItem(
              icon: ImageIcon(
                NetworkImage('https://robohash.org/beltran'),
              ),
              label: 'Profile')
        ],
      ),
    );
  }
}
