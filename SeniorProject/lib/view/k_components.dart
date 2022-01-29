import 'package:flutter/material.dart';

import 'k_colors.dart';
import 'k_styles.dart';


String? validatorForEmptyTextField (value) {
if (value == null || value.isEmpty) {
return 'Please enter some text';
}
return null;
}

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