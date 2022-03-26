import 'package:cyber/controller/user_controller.dart';
import 'package:cyber/globals.dart';
import 'package:cyber/view/avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../util/components.dart';
import '../util/k_colors.dart';
import '../util/k_styles.dart';
import '../util/k_values.dart';


class AllAvatarsPage extends StatelessWidget {
  const AllAvatarsPage({Key? key}) : super(key: key);

  static final routeName='/allAvatars';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Avatars",
          style: getSubheadingStyleBlue(),
        ),
        centerTitle: true,
        leading: getBackButton(context: context),
        backgroundColor: tertiaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        SizedBox(height: 0.05*heightOfScreen,),
        SubtitleDivider(subtitle: 'Collected'),
        SizedBox(height: 0.03*heightOfScreen,),
        SizedBox(
          width: widthOfScreen,
          height: 0.5*heightOfScreen,
          child: SingleChildScrollView(

            child: getAvatars(),
          ),
        ),

        SizedBox(height: 0.06*heightOfScreen,),
        Container(
          width: widthOfScreen,
          height: 0.2*heightOfScreen,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                  ])
          ),

          child: Image.asset(
            'assets/images/help.png',

          ),
        ),
          ],
        ),
      ),
    );
  }
}



getAvatars(){

   List<Widget> childrenOfRow=[];

   //I get the avatars from the active user
   List<String> userAvatars= activeUser!.collectedAvatars;


   //The user is always going to have at least one avatar so I dont
   //check for the user not having avatars
   for (String s in userAvatars){
     //The Avatars are going to be Obx because depend on the value of the vble activeUser
     childrenOfRow.add(
       AvatarButton(avatarName:s));
   }

   return Wrap(
     runSpacing: 10,
     spacing: 5,
     children: childrenOfRow,
   );

}

class AvatarButton extends StatelessWidget {


 AvatarButton({Key? key, required String this.avatarName}) : super(key: key);

  final String avatarName;

  ControllerActiveAvatar c = Get.put(ControllerActiveAvatar());

  @override
  Widget build(BuildContext context) {

    return Obx( ()=>ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), primary: c.activeAvatar==avatarName? secondaryColor: primaryColor),
      onPressed: (){  showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return AvatarDialog(avatarName: avatarName,);
          });},
      child: Avatar(nameOfAvatar: avatarName, size: 0.11*heightOfScreen),

    ));
  }
}




class AvatarDialog extends GetView<ControllerActiveAvatar> {
  const AvatarDialog({Key? key, required String this.avatarName}) : super(key: key);

  final String avatarName;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Avatar',style: getSubheadingStyleBlue(), textAlign: TextAlign.center,),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(nameOfAvatar: avatarName, size: 0.3*heightOfScreen),
          SizedBox(height: 0.05*heightOfScreen,),
          Text('Avatar ID: ${avatarName}', style: getNormalTextStyleBlue(),),

        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.pop(context, 'Cancel'),
          child: Text('Cancel',style: getNormalTextStyleBlue(),),
        ),
        TextButton(
          onPressed: ()  async {
              //We change the active User
              activeUser!.profilePictureActive=avatarName;

              controller.activeAvatar.value=avatarName;
              //We change the variable we are observing
              controller.update();


              String message='';
              await UserController.updateActiveUser().then((value){
                if(value){
                  message='Changes Applied';
                }else{
                  message='Changes not applied';
                }
              }).catchError((onError){
                message='Something went wrong';
              });

              var snackBar = SnackBar(
                backgroundColor: secondaryColor,
                content: Text(message, style: getNormalTextStyleWhite(),),
              );

              //ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
          },
          child:  Text('Change', style: getNormalTextStyleYellow(),),
        ),
      ],
    );
  }
}



class ControllerActiveAvatar extends GetxController{

  //The variable is obs which means observable
  var activeAvatar=activeUser!.profilePictureActive.obs;

}

