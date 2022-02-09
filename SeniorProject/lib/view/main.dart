import 'package:cyber/config/firebase_options.dart';
import 'package:cyber/view/join_group_sign_up.dart';
import 'package:cyber/view/k_colors.dart';
import 'package:cyber/view/profile_created.dart';
import 'package:cyber/view/sign_up_1.dart';
import 'package:cyber/view/sign_up_2.dart';
import 'package:cyber/view/sign_up_3.dart';
import 'package:cyber/view/summary_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'k_values.dart';
import 'log_in_page.dart';

void main() {
  runApp(
    //The notifier provider provides an instance of ApplicationState to all its descendants
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp(),
    ),
  );
}

enum ApplicationLoginState { loggedIn, loggedOut }

class ApplicationState extends ChangeNotifier {
  //We need to initialize this variable so we suppose the user is loggedOut
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    //With this method we initialize our app
    await Firebase.initializeApp();

    //Now we create a listener of the user state and after this we know the state of the user
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        _loginState = ApplicationLoginState.loggedOut;
      } else {
        _loginState = ApplicationLoginState.loggedIn;
      }
      notifyListeners();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        SignUpEmail.routeName: (context) => const SignUpEmail(),
        HomePage.routeName: (context) => const HomePage(),
        SignUpPassword.routeName: (context) => const SignUpPassword(),
        SignUpUsername.routeName: (context) => const SignUpUsername(),
        ProfileCreated.routeName: (context) => const ProfileCreated(),
        SignUpJoinGroup.routeName: (context) => const SignUpJoinGroup(),
        SignUpSummary.routeName: (context) => const SignUpSummary(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(0xFF14213D, primaryBlue),
                backgroundColor: MaterialColor(0xFF14213D, primaryBlue))
            .copyWith(
          secondary: MaterialColor(0xFFFCA311, secondaryYellow),
        ),
      ),
    );
  }
}

//Hola beltran

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static final routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    //In this page I get the information of the screen and I initialize it in variables stored in other file
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;

    //I update the height by subtracting the status bar height
    heightOfScreen = heightOfScreen - padding.top;

    //The builder from the consumer will be called everytime the Application state notifies its listeners

    return Consumer<ApplicationState>(builder: (context, appState, _) {
      switch (appState._loginState) {
        case ApplicationLoginState.loggedIn:
          {
            return SignUpSummary();
          }
        case ApplicationLoginState.loggedOut:
          {
            return LogInPage();
          }
        default:
          {
            return CircularProgressIndicator();
          }
      }
    });
  }
}
