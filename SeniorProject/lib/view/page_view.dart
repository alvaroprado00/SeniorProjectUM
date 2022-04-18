import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/view/dashboard/dashboard.dart';
import 'package:cyber/view/featured/featured_course.dart';
import 'package:cyber/view/groups/group_home_page.dart';
import 'package:cyber/view/profile/profile.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/active_user_controller.dart';
import '../controller/user_controller.dart';
import '../globals.dart';
import '../model/user_custom.dart';

class PageViewScreen extends StatelessWidget {
  const PageViewScreen({Key? key}) : super(key: key);
  static final routeName = '/PageViewScreen';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return PageViewScreenContent();
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: getNormalTextStyleBlue(),
            ),
          ));
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class PageViewScreenContent extends StatefulWidget {
  const PageViewScreenContent({Key? key}) : super(key: key);

  @override
  _PageViewScreenContentState createState() => _PageViewScreenContentState();
}

class _PageViewScreenContentState extends State<PageViewScreenContent> {
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
    ActiveUserController activeUserController = Get.find<ActiveUserController>();
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          DashboardPage(),
          FeaturedCoursePage(),
          GroupsHome(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: tertiaryColor,
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
                child: Obx(() => CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://robohash.org/${activeUserController.profilePictureActive}'),
                      backgroundColor: Colors.transparent,
                      radius: 12,
                    )),
              ),
              label: 'Profile')
        ],
      ),
    );
  }
}

Future initializeUser() async {
  try {
    //I get the active user
    UserCustom uc = await UserController.getActiveUser();

    //I initialize the global variable activeUser that is used by the GetX
    //controller to initialize the info
    activeUser = uc;

    if (Get.isRegistered<ActiveUserController>()) {
      Get.delete<ActiveUserController>();
    }
    Get.put(ActiveUserController());

    return Future.value('Done');
  } catch (error) {
    throw Exception('Error initializing the user');
  }
}
