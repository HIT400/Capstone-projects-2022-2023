import 'package:flutter/material.dart';

import '../config.dart';
import 'render_screen_height.dart';
import 'render_screen_width.dart';

onWarnBidder(context, title, subtitle) {
  double screenWidth = returnScreenWidth(context);
  double screenHeight = returnScreenHeight(context);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext popcontext, StateSetter stateSetter) {
          return AlertDialog(
            backgroundColor: darkcolor,
            title: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: regularfont,
                    color: Colors.white,
                    fontSize: screenWidth * 0.05)),
            content: Text(subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: regularfont,
                    color: Colors.white,
                    fontSize: screenWidth * 0.045)),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(popcontext).pop();
                },
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.05,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: darkcolor,
                      borderRadius: BorderRadius.circular(screenHeight * 0.025),
                      border: Border.all(width: 1, color: lightcolor)),
                  child: Text("Okay",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: regularfont,
                          color: lightcolor,
                          fontSize: screenWidth * 0.045)),
                ),
              ),
            ],
          );
        });
      });
}
