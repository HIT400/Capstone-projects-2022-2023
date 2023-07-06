import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../config.dart';
import 'render_screen_height.dart';
import 'render_screen_width.dart';

returnAppbar(context, title, key, type, onBackPressed) {
  double screenWidth = returnScreenWidth(context);
  double screenHeight = returnScreenHeight(context);
  return AppBar(
    toolbarHeight: screenHeight * 0.08,
    backgroundColor: darkcolor,
    elevation: 0,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            onBackPressed();
          },
          child: Icon(
            CupertinoIcons.arrow_left,
            size: screenWidth * 0.065,
            color: Colors.white,
          ),
        ),
      ],
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.003),
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: regularfont,
                  color: Colors.white,
                  fontSize: screenWidth * 0.045)),
        ),
      ],
    ),
    // ignore: prefer_const_literals_to_create_immutables
    actions: <Widget>[],
  );
}
