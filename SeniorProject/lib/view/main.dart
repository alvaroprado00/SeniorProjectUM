import 'package:cyber/view/k_colors.dart';
import 'package:cyber/view/log_in_page.dart';
import 'package:cyber/view/sign_up_1.dart';
import 'package:cyber/view/sign_up_2.dart';
import 'package:cyber/view/sign_up_3.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(0xFF14213D, primaryBlue),
                backgroundColor: MaterialColor(0xFF14213D, primaryBlue))
            .copyWith(
          secondary: MaterialColor(0xFFFCA311, secondaryYellow),
        ),
      ),
      home: const LogInPage(),
    );
  }
}
