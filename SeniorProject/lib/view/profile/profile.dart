import 'package:cyber/view/avatar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.buildContext}) : super(key: key);
  final BuildContext buildContext;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //final userCreated = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
        body: SafeArea(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hello"),
            // hello
            Avatar(
                url: 'https://robohash.org/beltran',
                size: 200), // userCreated.username
          ]),
    ));
  }
}
