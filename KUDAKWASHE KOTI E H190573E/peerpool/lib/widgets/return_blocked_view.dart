import 'package:flutter/material.dart';

import '../config.dart';
import 'render_screen_height.dart';
import 'render_screen_width.dart';

returnBlockedView(context, onContact) {
  double screenWidth = returnScreenWidth(context);
  double screenHeight = returnScreenHeight(context);
  return SizedBox(
    width: screenWidth,
    child: Container(
      color: Colors.red[800],
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02, horizontal: screenWidth * 0.055),
      child: Row(
        children: [
          Text(
            "Account Blocked",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
              fontFamily: lightfont,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              onContact();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.005),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.005),
                  border: Border.all(color: Colors.white)),
              child: Text(
                "CONTACT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.032,
                  fontFamily: regularfont,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
