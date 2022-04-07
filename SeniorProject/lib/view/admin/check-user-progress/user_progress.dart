
import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:flutter/material.dart';

import '../../../model/user_custom.dart';
import '../../util/components.dart';
import '../../util/functions.dart';
import '../../util/k_colors.dart';
import '../../util/k_styles.dart';

class UserProgressPage extends StatelessWidget {
  const UserProgressPage({Key? key}) : super(key: key);

  static final String routeName='userProgress';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'User Progress',
          style: getSubheadingStyleYellow(),
        ),
        centerTitle: true,
        elevation: 0,
        leading: getBackButton(context: context),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: UserController.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {

            if(snapshot.data.isEmpty){
              return Center(child: Text('No users in Database', style: getSubheadingStyleWhite(),),);
            }

            return UserProgressContent(users: snapshot.data,);

          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error when getting users',
                style: getSubheadingStyleWhite(),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ));
          }
        },
      ),
    );
  }
}


class UserProgressContent extends StatefulWidget {
  const UserProgressContent({Key? key, required this.users}) : super(key: key);

  //Here I have the list of users in the Database which i will use
  //to get the user that the admin wants to know about
  final List<UserCustom> users;


  @override
  _UserProgressContentState createState() => _UserProgressContentState();
}

class _UserProgressContentState extends State<UserProgressContent> {

  late final _controllerUsername;
  late final _formKey;
  late  bool _userSearched;
  late  bool _userValid;
  late  String _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
    _controllerUsername=TextEditingController();
    _userSearched=false;
    _userValid=false;
    _username='';
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void Function() formFunction=(){
      if(_formKey.currentState!.validate()){
        setState(() {
          _userSearched=true;
          _username=_controllerUsername.text.trim();
          if(checkIfUsernameExists(username: _username)){
            _userValid=true;
          }else{
            _userValid=false;
          }
        });
      }
    };

    return Padding(
      padding:EdgeInsets.only(left: 0.1*widthOfScreen, right: 0.1*widthOfScreen),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.03*heightOfScreen,),
            Text('Enter the username of the user whose progress you want to see', style: getNormalTextStyleWhite(), textAlign: TextAlign.center,),
            SizedBox(height: 0.03*heightOfScreen,),

            Form(
              key: _formKey,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:0.6*widthOfScreen,
                      child: TextFormField(
                        validator: validatorForEmptyTextField,
                        controller: _controllerUsername,
                        decoration: getInputDecoration(
                          hintText: 'Username',
                            icon: Icon(
                              Icons.person,
                              color: secondaryColor,
                            ),
                        ),
                      ),
                    ),

                    IconButton(onPressed: formFunction, icon: Icon(Icons.search, color: secondaryColor,)),
                  ],
                )
            ),

            _userSearched?
                ContentForUser(users: widget.users, username: _username, isValid: _userValid):SizedBox(width: 0, height: 0,),
          ],

        ),
      ),
    );
  }

  bool checkIfUsernameExists({required String username}){
    for (UserCustom u in widget.users){
      if(u.username.toLowerCase()==username.toLowerCase()){
        return true;
      }
    }
    return false;
  }
}

class ContentForUser extends StatelessWidget {
  const ContentForUser({Key? key, required List<UserCustom> this.users, required String this.username, required bool this.isValid}) : super(key: key);

  final List<UserCustom> users;
  final String username;
  final bool isValid;


  @override
  Widget build(BuildContext context) {
    return
      isValid? UserOverview(user:users.where((element) => element.username.toLowerCase()==username.toLowerCase()).first):
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.2*heightOfScreen,),
              Text('User not found', style: getSubheadingStyleWhite(),),
              Icon(Icons.person, color: secondaryColor, size: 0.3*heightOfScreen,),
            ],
          );

  }
}

class UserOverview extends StatelessWidget {
  const UserOverview({Key? key, required UserCustom this.user}) : super(key: key);

  final UserCustom user;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 0.1*heightOfScreen,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user.isAdmin? 'Admin': 'Normal User', style: getSubheadingStyleYellow(),),

            Text(user.email, style: TextStyle(fontFamily: 'Roboto', fontSize: 10, color: tertiaryColor),),
          ],
        ),
        SizedBox(height: 0.03*heightOfScreen,),

        Container(
            child: Avatar(nameOfAvatar: user.profilePictureActive, size: 0.2*heightOfScreen),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: secondaryColor
            )),
        SizedBox(height: 0.03*heightOfScreen,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user.username, style: getSubheadingStyleWhite(), textAlign: TextAlign.center,),
            Text('Level ${user.level.levelNumber}', style: getSubheadingStyleWhite(), textAlign: TextAlign.center,),
          ],
        ),
        SizedBox(height: 0.05*heightOfScreen,),

        ProgressIndicator(label: 'Courses Saved', num: user.coursesSaved.length),
        ProgressIndicator(label: 'Courses Completed', num: user.completedCourses.length),
        ProgressIndicator(label: 'Badges Earned', num: user.collectedBadges.length),
        ProgressIndicator(label: 'Avatars earned', num: user.collectedAvatars.length),
      ],
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({Key? key, required this.label, required this.num}) : super(key: key);

  final String label;
  final int num;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.center,
         children:[ Text(label, style: getNormalTextStyleWhite(),),
         Text(num.toString(), style: getNormalTextStyleYellow(),)],
        ),
        Divider(color: tertiaryColor, thickness: 2,),

      ],

    );
  }
}

