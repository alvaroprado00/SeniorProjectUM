/*
  Code collected from:
  https://github.com/bizz84/coding-with-flutter-robohash-demo/blob/master/lib/avatar.dart

  It defines a class to be able to fetch the robohash page and get an avatar picture
  It works using Future Builder which means that while you wait for Robohash response it displays a progress indicator
 */

import 'dart:async';
import 'dart:typed_data';

import 'package:cyber/view/k_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Avatar extends StatefulWidget {
  Avatar({required this.url, required this.size});
  final String url;
  final double size;
  @override
  State<StatefulWidget> createState() => new _AvatarState();
}

class _AvatarState extends State<Avatar> {
  Future<Uint8List> fetchAvatar() async {
    http.Response response = await http.get(Uri.parse(widget.url));
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
            padding: EdgeInsets.all((widget.size - 50.0) / 2.0),
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: widget.size,
      height: widget.size,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: secondaryColor,
            width: 2.0,
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black12,
              ])),
      child: new ClipOval(
        child: loadingWidget(),
      ),
    );
  }
}