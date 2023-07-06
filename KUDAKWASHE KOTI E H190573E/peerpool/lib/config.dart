import 'package:flutter/material.dart';

var darkcolor = const Color.fromARGB(255, 1, 44, 44);
var lightcolor = const Color.fromARGB(255, 86, 186, 186);
var version = "1.0.1";

var boldfont = "Lato Bold";
var regularfont = "Lato Regular";
var italicfont = "Lato Italic";
var thinfont = "Lato Thin";
var lightfont = "Lato Light";

var apiKey = "AIzaSyB16Cyd2PJDJJ81df87b-S3LfUlffUmqR8";
var serverKey =
    "AAAAu-OtPg0:APA91bEmtHSlKLiVo9lX730tSb9fixl1RkBnEufvvz8_qA41eVOdBQecczS2McHq_XiykFb_m1D4d4xYjbNT7uCvWTUfKSfmDNG-a0fQBWj34OUP6UqykA_dyEWvtCTISIwFQFo3m7KV";

Map<String, String> headers = {
  "Authorization": "key=$serverKey",
  "Content-Type": "application/json"
};
