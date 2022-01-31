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
    final userCreated = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 73, bottom: 53),
              child: Align(child: Text('Say hello to yourself.', style: subheadingStyleWhite,))
            ),
            
            Avatar(url: 'https://robohash.org/${userCreated.username}', size: 200),

            Padding(
                padding: const EdgeInsets.only(top: 28, bottom: 51),
                child: Align(child: Text(userCreated.username, style: subheadingStyleYellow,)),
            ),

            Divider(indent: 16, endIndent: 16, color: secondaryColor,thickness: 1,),

            Padding(
              padding: const EdgeInsets.only(left: 34, top: 20, bottom: 20),
              child: Row(children:[Icon(Icons.mail, color: secondaryColor,), Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(userCreated.email, style: smallTextStyle,),
              )]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Row(children:[Icon(Icons.lock, color: secondaryColor,), Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text('********', style: smallTextStyle, ),
              )]),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0,40, 0, 0),
              child: SizedBox(
                  height: 54,
                  width: 358,
                  child: ElevatedButton(
                    onPressed: () => print('popo'),
                    child: Text('Next', style: normalTextStyle),
                    style: largeGreyButtonStyle,
                  )),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0,16, 0, 35),
              child: getCirclesProgressBar(position:4, numberOfCircles: 5),
            ),
          ],
        ),
      ),
    );
  }
}
