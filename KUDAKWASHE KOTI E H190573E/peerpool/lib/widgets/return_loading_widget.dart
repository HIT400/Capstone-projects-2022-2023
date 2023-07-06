import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

returnLoadingWidget(context, mode) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    alignment: Alignment.center,
    child: LoadingIndicator(
      colors: [mode == "light" ? Colors.white : Colors.grey[800]],
      indicatorType: Indicator.ballBeat,
      strokeWidth: 0.2,
    ),
  );
}
