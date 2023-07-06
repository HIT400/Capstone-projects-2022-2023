import 'package:flutter/material.dart';

returnFontSize(context, percentage) {
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * percentage;
}
