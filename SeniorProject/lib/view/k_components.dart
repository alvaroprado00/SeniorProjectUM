import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_styles.dart';


/**
 * Validator for TextFormField. It verifies the value is not empty
 */
String? validatorForEmptyTextField (value) {
if (value == null || value.isEmpty) {
return 'Please enter some text';
}
return null;
}

/**
 * Function to get an Input Decoration for a text field providing the Icon and the hint Text wanted
 */
InputDecoration getInputDecoration ({required String hintText, required Icon icon}){
  return InputDecoration(
    filled: true,
fillColor: tertiaryColor,
hintText: hintText,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: tertiaryColor, width: 1.0),
),
prefixIcon: icon,
hintStyle: textFieldStyle,
);
}


/**
 * Function to create a row of dots. The number specified in position will be colored yellow.
 * Used as a progress Indicator
 */
Widget getCirclesProgressBar({required int position, required int numberOfCircles}){
  final children = <Widget>[];

  for(var i=1; i<=numberOfCircles; i++){
    if(position==i){
      children.add(getCircle(color: secondaryColor));
    }else{
      children.add(getCircle(color: quinaryColor));
    }
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:children,
  );
}


Widget getCircle({required Color color}){

  return Padding(
    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
    child: SizedBox(
      width: 8,
      height: 8,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle
        ),
      ),
    ),
  );
}


/**
 * Function that returns an back button. You need to specify the context so the
 * function in the onPressed parm makes sense. You also need to provide the height
 * of the Screen
 */

IconButton getBackButton({required BuildContext context, required double heightOfScreen}){
  return IconButton(
      onPressed: (){Navigator.pop(context);},
  icon: Icon(
  Icons.chevron_left,
  color: secondaryColor,
  size: 0.06 * heightOfScreen,
  ));
}


Card getCardForUnsavedCourse({required String nameOfCourse, required double width, required double height}){
  return Card(
    
    color: primaryColor,
    borderOnForeground: true,
    shape:
      new RoundedRectangleBorder(
        side: new BorderSide(color: tertiaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0)),

    child: InkWell(
      splashColor: secondaryColor,
      onTap: () {
        debugPrint('Card tapped.');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          SizedBox(width: width,child: Align(alignment: Alignment.centerRight,child: SaveButton())),
          SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.only(left: 0.05*width, bottom: height*0.05) ,
            child: Align(alignment: Alignment.bottomLeft ,child: Text('$nameOfCourse', style: normalTextStyleWhite)),
          ),
        ),
        ]
      ),
    ),
  );
}


class SaveButton extends StatefulWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _filled=false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        //Do whatever logic in the future
        setState(() {
          _filled = !_filled;
        });
      },
      icon: _filled ? Icon(Icons.bookmark, color: secondaryColor,) : Icon(
        Icons.bookmark_border, color: secondaryColor,),
    );
  }
}
