import 'package:cyber/view/admin/new_course_page_1.dart';
import 'package:cyber/view/dashboard/dashboard.dart';
import 'package:cyber/view/profile/profile.dart';
import 'package:cyber/view/useful/k_colors.dart';
import 'package:cyber/view/useful/k_values.dart';
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

  int _selectedIndex = 0;

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          DashboardPage(),
          NewCoursePage(),
          ProfilePage(buildContext: context),
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
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: 'Courses'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.suit_diamond), label: 'Featured'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded), label: 'Groups'),
          BottomNavigationBarItem(
              icon:
                  //ImageIcon(
                  Container(
                padding: EdgeInsets.only(bottom: heightOfScreen * 0.002),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 0.5)),
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://robohash.org/beltran'),
                  backgroundColor: Colors.transparent,
                  radius: 12,
                ),
              ),
              label: 'Profile')
        ],
      ),
    );
  }
}
