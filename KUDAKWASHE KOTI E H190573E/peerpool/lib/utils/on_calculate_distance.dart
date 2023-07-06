import 'dart:math';

import 'package:geolocator/geolocator.dart';

Object onCalculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return double.parse(((12742 * asin(sqrt(a))) / 1000).toString())
      .toStringAsPrecision(5)
      .substring(0, 4)
      .toString();
  //return Geolocator.distanceBetween(lat1, lon1, lat2, lon2).toStringAsFixed(0);
}
