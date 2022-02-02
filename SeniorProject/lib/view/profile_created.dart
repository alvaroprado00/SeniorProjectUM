import 'package:cyber/model/user.dart';
import 'package:cyber/view/avatar.dart';
import 'package:cyber/view/k_styles.dart';
import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_components.dart';


class ProfileCreated extends StatelessWidget {
  const ProfileCreated({Key? key}) : super(key: key);

  static final routeName= '/ProfileCreated';


  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    height = height - padding.top;

    final userCreated = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top:0.05*height, bottom:0.05*height),
              child: Align(child: Text('Say hello to yourself.', style: getSubheadingStyleWhite(widthOfScreen: width),))
            ),
            
            Avatar(url: 'https://robohash.org/${userCreated.username}', size: width*0.5),

            Padding(
              padding: EdgeInsets.only(top:0.05*height, bottom:0.05*height),
                child: Align(child: Text(userCreated.username, style: getSubheadingStyleWhite(widthOfScreen: width),)),
            ),

            Divider(indent: width*0.025, endIndent: width*0.025, color: secondaryColor,thickness: 1,),

            Padding(
              padding: EdgeInsets.only( left: 0.1*width , top:0.03*height, bottom:0.03*height),
              child: Row(children:[Icon(Icons.mail, color: secondaryColor,), Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(userCreated.email, style: getSmallTextStyle(widthOfScreen: width),),
              )]),
            ),

            Padding(
              padding: EdgeInsets.only( left: 0.1*width,  bottom:0.17*height),
              child: Row(children:[Icon(Icons.lock, color: secondaryColor,), Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text('********', style: getSmallTextStyle(widthOfScreen: width), ),
              )]),
            ),

            SizedBox(
                height: 54,
                width: 358,
                child: ElevatedButton(
                  onPressed: () => print('popo'),
                  child: Text('Next', style: getNormalTextStyleBlue(widthOfScreen: width)),
                  style: largeGreyButtonStyle,
                )),

            Padding(
              padding: EdgeInsets.only(top: 0.03*height),
              child: getCirclesProgressBar(position:4, numberOfCircles: 5,widthOfScreen: width),
            ),
          ],
        ),
      ),
    );
  }
}
