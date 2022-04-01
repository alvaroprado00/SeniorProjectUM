/**
 *   Code collected from:
 *   https://github.com/bizz84/coding-with-flutter-robohash-demo/blob/master/lib/avatar.dart
 *
 *   It defines a class to be able to fetch the robohash page and get an avatar picture
 *   It works using Future Builder which means that while you wait for Robohash response it displays a progress indicator
*/

import 'dart:async';
import 'dart:typed_data';

import 'package:cyber/controller/active_user_controller.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:cyber/view/util/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class Avatar extends StatelessWidget {
  Avatar({required this.nameOfAvatar, required this.size});
  final String nameOfAvatar;
  final double size;
  late final String url;

  Future<Uint8List> fetchAvatar() async {
    http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Widget loadingWidget() {
    return new FutureBuilder<Uint8List>(
      future: fetchAvatar(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Image.memory(snapshot.data!);
        } else if (snapshot.hasError) {
          print('${snapshot.error}');
          return new Center(
              child: new Text('❌', style: TextStyle(fontSize: 72.0)));
        } else {
          return new Container(
            padding: EdgeInsets.all((size) / 2.0), //-50
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    url = 'http://robohash.org/${nameOfAvatar}';
    return new Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: primaryColor,
            width: 2.0,
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white38,
              ])),
      child: new ClipOval(
        child: loadingWidget(),
      ),
    );
  }
}
