import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

import '../config.dart';

returnErrorWidget(context, title, subtitle) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return Container(
    height: screenHeight * 0.7,
    alignment: Alignment.center,
    child: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              LineIcons.car,
              size: screenWidth * 0.3,
              color: Colors.grey[700],
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1),
                child: Text("$title",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: lightfont,
                        color: Colors.grey[700],
                        fontSize: screenWidth * 0.052))),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  left: screenWidth * 0.17,
                  right: screenWidth * 0.17),
              child: Text("$subtitle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: lightfont,
                      color: Colors.grey[700],
                      fontSize: screenWidth * 0.029)),
            ),
          ]),
        )),
  );
}
