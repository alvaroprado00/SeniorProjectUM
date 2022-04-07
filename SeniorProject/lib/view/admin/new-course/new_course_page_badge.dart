import 'package:cyber/config/fixed_values.dart';
import 'package:cyber/view/admin/new-course/new_question_page.dart';
import 'package:cyber/view/util/components.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_styles.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:cyber/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/course.dart';
import '../../util/functions.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({Key? key}) : super(key: key);

  static final String routeName='/newBadge';
  @override
  Widget build(BuildContext context) {
    final newCourse = ModalRoute.of(context)!.settings.arguments as Course;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Badge',
          style: getSubheadingStyleWhite(),
        ),
        leading: getBackButton(context: context),
        actions: [getExitButtonAdmin(context: context)],
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: BadgePageContent(newCourse: newCourse,),
      ),
    );
  }
}

class BadgePageContent extends StatefulWidget {
  const BadgePageContent({Key? key, required Course this.newCourse}) : super(key: key);

  final Course newCourse;

  @override
  _BadgePageContentState createState() => _BadgePageContentState();
}

class _BadgePageContentState extends State<BadgePageContent> {
  late bool _badgeSelected;
  late bool _badgeValid;
  late String _nameBadge;
  late final TextEditingController _controllerBadge;
  late final String _url;
  late final _formKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _badgeSelected = false;
    _badgeValid = false;
    _nameBadge = '';
    _controllerBadge = TextEditingController();
    _url = 'https://fontawesome.com/icons';
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controllerBadge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function() formFunction = () {
      if (_formKey.currentState!.validate()) {
        //The form has been submitted with some data

        setState(() {
          if (FontAwesomeIconsMap[_controllerBadge.text] != null) {
            //There is a match in the map
            _badgeSelected = true;
            _badgeValid = true;
            _nameBadge=_controllerBadge.text;
          } else {
            _badgeSelected = true;
            _badgeValid = false;
          }
        });
      }
    };

    return Padding(
      padding: EdgeInsets.only(left: 0.1*widthOfScreen, right: 0.1*widthOfScreen),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please enter a badge name.',
                style: getNormalTextStyleWhite(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.03*heightOfScreen,),

              Text(
                'To enter a valid badge name, go to the following link. Search for an icon and enter the name in camelCase format. If the style picked is not regular then use the style as prefix.',
                style: getSmallTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.03*heightOfScreen,),


              InkWell(
                child: new Text(
                  'Font Awesome',
                  style: getNormalTextStyleYellow(),
                ),
                onTap: () => _launchURL(),
              ),

              SizedBox(height: 0.05*heightOfScreen,),

              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: validatorForEmptyTextField,
                      controller: _controllerBadge,
                      decoration: getInputDecoration(
                        hintText: 'Icon name',
                        icon: Icon(
                          Icons.photo,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.03*heightOfScreen,),

                    SizedBox(
                      height: getHeightOfSmallButton(),
                      width: getWidthOfSmallButton(),
                      child: ElevatedButton(
                        onPressed: formFunction,
                        child: Text('Submit', style: getNormalTextStyleWhite(),),
                        style: yellowButtonStyle,
                      ),
                    )
                  ],
                ),
              ),

              _badgeSelected?
                  BadgeContent( badgeValid:_badgeValid, nameBadge:_nameBadge, newCourse: widget.newCourse):
                  SizedBox(height: 0.44*heightOfScreen),

              getCirclesProgressBar(position: 4, numberOfCircles: 4),
            ]),
      ),
    );
  }

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}


class BadgeContent extends StatelessWidget {
  const BadgeContent({Key? key, required String this.nameBadge, required bool this.badgeValid, required this.newCourse}) : super(key: key);

  final String nameBadge;
  final Course newCourse;
  final bool badgeValid;

  @override
  Widget build(BuildContext context) {

   void Function() setBadge=(){

     //Last field required to build the course
     newCourse.badgeIcon=nameBadge;

     // I have to set the global variable to 1

     globals.newQuestionNum = 1;

     //Instead of passing the formed new-course to the next page
     //I will create a global variable since
     //the page NewQuestionPage is going to be receiving
     //questions as arguments

     globals.newCourse = newCourse;

     Navigator.pushNamed(context, NewQuestionPage.routeName);

   };
    return
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:badgeValid? [
            getContainerForBadge(nameOfIcon: nameBadge, size: 0.3*heightOfScreen),
            SizedBox(height: 0.04 * heightOfScreen),
            getNextButton(todo: setBadge, large: true),
            SizedBox(height: 0.04 * heightOfScreen),

          ]:[
            SizedBox(height: 0.05 * heightOfScreen),

            Icon(Icons.clear, color: secondaryColor,size: 0.3*heightOfScreen, ),
            Text('No icon found, try again',style: getSubheadingStyleWhite(),),
            SizedBox(height: 0.06 * heightOfScreen),

          ],
        );
  }
}
