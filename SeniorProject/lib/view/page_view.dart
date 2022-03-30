import 'package:cyber/view/dashboard/dashboard.dart';
import 'package:cyber/view/profile/profile.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin/new-course/new_course_page.dart';
import 'groups/group_home_page.dart';

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
          GroupHome(),
          ProfilePage(
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
              activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: 'Courses'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star),
            activeIcon: Icon(CupertinoIcons.star_fill),
            label: 'Featured',
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2),
              activeIcon: Icon(CupertinoIcons.person_2_fill),
              label: 'Groups'),
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
