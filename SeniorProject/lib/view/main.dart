import 'package:cyber/view/admin/dashboard/admin_dashboard.dart';
import 'package:cyber/view/admin/new-course/new_course_page.dart';
import 'package:cyber/view/admin/new-course/new_course_page_description.dart';
import 'package:cyber/view/admin/new-course/new_course_page_outcomes.dart';
import 'package:cyber/view/admin/new-course/new_question_feedback_page.dart';
import 'package:cyber/view/admin/new-course/new_question_page.dart';
import 'package:cyber/view/admin/recommended/new_recommended_page.dart';
import 'package:cyber/view/courses/category_progress.dart';
import 'package:cyber/view/courses/course_description.dart';
import 'package:cyber/view/courses/multiple_choice_question_page.dart';
import 'package:cyber/view/page_view.dart';
import 'package:cyber/view/sign-up/email_page.dart';
import 'package:cyber/view/sign-up/join_group_sign_up.dart';
import 'package:cyber/view/sign-up/password_page.dart';
import 'package:cyber/view/sign-up/profile_created.dart';
import 'package:cyber/view/sign-up/summary_sign_up.dart';
import 'package:cyber/view/sign-up/username_page.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin/new-course/new_fill_blanks_page_blanks.dart';
import 'admin/new-course/new_fill_blanks_page_text.dart';
import 'admin/new-course/new_multiple_choice_page_description.dart';
import 'admin/new-course/new_multiple_choice_page_options.dart';
import 'courses/category.dart';
import 'courses/fill_in_the_blanks_question_page.dart';
import 'courses/overview.dart';
import 'dashboard/dashboard.dart';
import 'log_in_page.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();

  runApp(
    //The notifier provider provides an instance of ApplicationState to all its descendants
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => const MyApp(),
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
        SignUpEmailPage.routeName: (context) => const SignUpEmailPage(),
        HomePage.routeName: (context) => const HomePage(),
        SignUpPasswordPage.routeName: (context) => const SignUpPasswordPage(),
        SignUpUsernamePage.routeName: (context) => const SignUpUsernamePage(),
        ProfileCreated.routeName: (context) => const ProfileCreated(),
        PageViewScreen.routeName: (context) =>
            PageViewScreen(buildContext: context),

        SignUpSummary.routeName: (context) => const SignUpSummary(),
        MultipleChoiceQuestionPage.routeName: (context) =>
            const MultipleChoiceQuestionPage(),
        FillInTheBlanksQuestionPage.routeName: (context) =>
            const FillInTheBlanksQuestionPage(),
        NewCoursePage.routeName: (context) => const NewCoursePage(),
        NewCourseOutcomesPage.routeName: (context) =>
            const NewCourseOutcomesPage(),
        NewCourseDescriptionPage.routeName: (context) =>
            const NewCourseDescriptionPage(),
        NewQuestionPage.routeName: (context) => const NewQuestionPage(),
        DashboardPage.routeName: (context) => const DashboardPage(),
        CategoryPage.routeName: (context) => const CategoryPage(),
        CourseDescription.routeName: (context) => const CourseDescription(),
        Overview.routeName: (context) => const Overview(),
        CategoryProgress.routeName: (context) => const CategoryProgress(),
        SignUpGroupPage.routeName: (context) => const SignUpGroupPage(),
        SignUpSummary.routeName: (context) => const SignUpSummary(),
        MultipleChoiceQuestionPage.routeName: (context) =>
            const MultipleChoiceQuestionPage(),
        FillInTheBlanksQuestionPage.routeName: (context) =>
            const FillInTheBlanksQuestionPage(),
        NewCoursePage.routeName: (context) => const NewCoursePage(),
        NewCourseOutcomesPage.routeName: (context) =>
            const NewCourseOutcomesPage(),
        NewCourseDescriptionPage.routeName: (context) =>
            const NewCourseDescriptionPage(),
        NewQuestionPage.routeName: (context) => const NewQuestionPage(),
        MultipleChoiceDescriptionPage.routeName: (context) =>
            const MultipleChoiceDescriptionPage(),
        MultipleChoiceOptionsPage.routeName: (context) =>
            const MultipleChoiceOptionsPage(),
        QuestionLongFeedbackPage.routeName: (context) =>
            const QuestionLongFeedbackPage(),
        FillInTheBlanksTextPage.routeName: (context) =>
            const FillInTheBlanksTextPage(),
        FillInTheBlanksOptionsPage.routeName: (context) =>
            const FillInTheBlanksOptionsPage(),
        DashboardPage.routeName: (context) => const DashboardPage(),
        CategoryPage.routeName: (context) => const CategoryPage(),
        CourseDescription.routeName: (context) => const CourseDescription(),
        Overview.routeName: (context) => const Overview(),
        CategoryProgress.routeName: (context) => const CategoryProgress(),
        NewRecommendedCoursePage.routeName: (context) =>
            const NewRecommendedCoursePage(),
        AdminDashboardPage.routeName: (context) => const AdminDashboardPage(),
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
            // FirebaseAuth.instance.signOut();
            //return DashboardPage();
            return PageViewScreen(buildContext: context);
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
