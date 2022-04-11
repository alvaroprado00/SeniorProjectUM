import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../avatar.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:flutter/material.dart';

import 'components.dart';
import 'functions.dart';
import 'k_colors.dart';
import 'k_styles.dart';
import 'k_values.dart';

/**
 * This function Retrieves a card with the title of the new-course specified.
 *
 * Yoy need to Specify the width of the card as well as the height of the sized
 * box containing everything
 *
 * It is necessary to specify if the card is or not a template. In case it is not,
 * then using the argument context and the courseId, when pressed it will
 * redirect the user to the page CourseDescription
 *
 * The argument courseID and isSaved are only used for non-template cards. Thats
 * why they are optional. The Save Button needs both those param
 */

Card getCardForCourse(
    {String courseID = '',
    bool isSaved = false,
    bool isCompleted = false,
    required BuildContext context,
    required String title,
    required double widthOfCard,
    required double heightOfCard,
    required bool isTemplate}) {
  void Function() navigateToCourse = () {
    Navigator.pushNamed(context, CourseDescription.routeName,
        arguments: courseID);
  };

  return Card(
    color: primaryColor,
    borderOnForeground: true,
    shape: new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    child: InkWell(
      splashColor: secondaryColor,
      onTap: isTemplate
          ? () {
              print('This is a template');
            }
          : navigateToCourse,
      child: SizedBox(
        height: heightOfCard,
        width: widthOfCard,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isCompleted
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: secondaryColor,
                    )
                  : SizedBox(
                      width: 0,
                    ),
              isTemplate
                  ? Icon(Icons.bookmark, color: secondaryColor)
                  : SaveButton(isFilled: isSaved, courseID: courseID),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.05 * widthOfCard, bottom: heightOfCard * 0.05),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('$title', style: getNormalTextStyleWhite())),
          ),
        ]),
      ),
    ),
  );
}

/**
 * This class defines the Save Button logic included in the new-course Cards
 * When created we specify the first state of the button with the boolean
 * isFilled. We also need the button to have the new-course ID to save/unsave that
 * new-course.
 *
 */
class SaveButton extends StatefulWidget {
  SaveButton({required bool this.isFilled, required String this.courseID});

  bool isFilled;
  final String courseID;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    ActiveUserController activeUserController = Get.find();

    return IconButton(
      onPressed: () {
        //When pressed we check if the courses is or not
        //saved and we execute the corresponding function

        if (widget.isFilled) {
          activeUserController.unsaveCourse(courseID: widget.courseID);
          //activeUser!.unsaveCourse(courseID:widget.courseID);

        } else {
          activeUserController.saveCourse(courseID: widget.courseID);
          //activeUser!.saveCourse(courseID:widget.courseID);
        }

        setState(() {
          widget.isFilled = !widget.isFilled;
        });
      },
      icon: widget.isFilled
          ? Icon(
              Icons.bookmark,
              color: secondaryColor,
            )
          : Icon(
              Icons.bookmark_border,
              color: secondaryColor,
            ),
    );
  }
}

/**
 * Gets a tapable card with the name of the category. You have to specify the
 * width and the height.
 *
 * V 1.0 (2/8/22) Does nothing when tapped
 *
 * V 2.0 (3/8/22) Now when the card is tapped is navigates to the category itself
 * You also need to specify if it is a template Card. In case this param is set
 * to true, the card does nothing when tapped.
 *
 * Param: context. If the card is not a template we need a build context
 * from which we navigate from. Even stated that we only use it when template is
 * false, we have to make it required because its nature makes unable to assign
 * null as a value
 */

Card getCardForCategory(
    {required BuildContext context,
    required Category category,
    required double widthOfCard,
    required double heightOfCard,
    String routeToNavigate = '',
    dynamic arguments,
    required bool isTemplate}) {
  //Function to be executed if the card is not a template
  void Function() navigateToCategory = () {
    Navigator.pushNamed(context, routeToNavigate, arguments: arguments);
  };

  return Card(
    color: primaryColor,
    borderOnForeground: true,
    shape: new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    child: InkWell(
      splashColor: secondaryColor,
      onTap: isTemplate
          ? () {
              print('Does nothing');
            }
          : navigateToCategory,
      child: SizedBox(
        width: widthOfCard,
        height: heightOfCard,
        child: Align(
            alignment: Alignment.center,
            child: Text(categoryToString[category]!,
                style: getNormalTextStyleWhite())),
      ),
    ),
  );
}

/**
 * Getter fot a notification card. We need to specify de username and the new-course
 * he has completed so it appears as the info displayed. Width and height need
 * to be specified.
 */

Card getCardForNotification(
    {required String username,
      required String nameOfCourse,
      required double widthOfCard,
      required double heightOfCard,
    }) {
  return Card(
    color: primaryColor,
    borderOnForeground: true,
    shape: new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),
    child: InkWell(
      splashColor: secondaryColor,
      onTap: () {
        debugPrint('Redirected to new-course bla bla.');
      },
      child: SizedBox(
          width: widthOfCard,
          height: heightOfCard,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 0.025 * widthOfCard, right: 0.025 * widthOfCard),
              child: Avatar(nameOfAvatar: username, size: widthOfScreen * 0.1),
            ),
            Flexible(
              child: Text(
                  '$username just completed a new course on $nameOfCourse. ${getRandomEncouragingMessage()}',
                  style: getNormalTextStyleWhite()),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.025 * widthOfCard, right: 0.025 * widthOfCard),
              child: Icon(
                Icons.password,
                color: secondaryColor,
              ),
            ),
          ])),
    ),
  );
}

getNotificationTile({required String username,
  required String message,
  required String badgeImage,}) {
  return ListTile(
    tileColor: quinaryColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
    leading: Avatar(nameOfAvatar: username, size: widthOfScreen * 0.1),
    title: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: username == activeUser!.username ? "You" : username,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF14213D),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' ',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF14213D),
              fontFamily: 'Roboto',
            ),
          ),
          TextSpan(
            text: message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF14213D),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
    trailing: getContainerForBadge(
      nameOfIcon: badgeImage,
      size: widthOfScreen * 0.1,
    ),
    onTap: () {},
  );
}

/**
 * Function to get a grey container with the shape of a course card
 * to show a placeholder
 */
getCourseCardPlaceHolder() {
  return Container(
    width: 0.4 * widthOfScreen,
    height: 0.12 * heightOfScreen,
    decoration: BoxDecoration(
        color: quinaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}
