import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

returnEmptyContainer() {
  return const SizedBox(height: 0, width: 0);
}

returnEmptyWidget(context, title, subtitle) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return Container(
    height:
        title == "No Products Found" ? screenHeight * 0.85 : screenHeight * 0.7,
    alignment: Alignment.center,
    child: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              title == "No Products Found"
                  ? CupertinoIcons.cart_badge_minus
                  : CupertinoIcons.videocam_circle_fill,
              size: screenWidth * 0.3,
              color: Colors.grey[700],
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: 15, left: screenWidth * 0.1, right: screenWidth * 0.1),
                child: Text("$title",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lato Italic",
                        color: Colors.grey[700],
                        fontSize: screenWidth * 0.052))),
            Padding(
              padding: EdgeInsets.only(
                  top: 15, left: screenWidth * 0.09, right: screenWidth * 0.09),
              child: Text("$subtitle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "Lato Regular",
                      color: Colors.grey[700],
                      fontSize: screenWidth * 0.029)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
            ),
          ]),
        )),
  );
}
