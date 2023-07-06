import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../utils/on_send_otp.dart';
import '../utils/on_verify_otp.dart';
import '../widgets/render_screen_height.dart';
import '../widgets/render_screen_width.dart';
import '../widgets/return_empty_container.dart';
import '../widgets/return_loading_widget.dart';
import '../widgets/shared_prefs.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController loginnumber = TextEditingController();
  final TextEditingController loginpassword = TextEditingController();
  final TextEditingController _loginverify = TextEditingController();

  final TextEditingController forgotemail = TextEditingController();
  final TextEditingController forgotpassword1 = TextEditingController();
  final TextEditingController forgotpassword2 = TextEditingController();

  final TextEditingController signupfirstname = TextEditingController();
  final TextEditingController signupsurname = TextEditingController();
  final TextEditingController signupphone = TextEditingController();
  final TextEditingController signupemail = TextEditingController();
  final TextEditingController signupreferemail = TextEditingController();
  final TextEditingController signuppassword = TextEditingController();
  final TextEditingController signupconfirmpassword = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();

  int phase = 1;

  String mode = "";
  String emailN = "";
  String verificationcode = "";

  bool isverifying = false;
  bool istimeoutover = false;
  bool isresending = false;
  bool issending = false;
  bool isresetting = false;
  bool showpassword = false;
  bool showpasswordsignup = false;
  bool signinloading = false;
  bool signuploading = false;
  bool floading = false;

  Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 0) {
          setState(() {
            _timer.cancel();
            istimeoutover = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  onBackPressed() {}

  onChangePasswordVisibility() async {
    setState(() {
      showpassword = !showpassword;
    });
  }

  onChangePasswordVisibilitySignUp() async {
    setState(() {
      showpasswordsignup = !showpasswordsignup;
    });
  }

  onForgotPassword() async {
    setState(() {
      _start = 60;
      forgotemail.text = "";
      forgotpassword1.text = "";
      forgotpassword2.text = "";
      phase = 4;
    });
  }

  onResetPassword() async {
    double screenWidth = returnScreenWidth(context);

    var fpass1 = forgotpassword1.text.trim();
    var fpass2 = forgotpassword2.text.trim();

    if (fpass1.isEmpty || fpass2.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any fields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: darkcolor,
          textColor: Colors.white,
          fontSize: screenWidth * 0.037);
    } else {
      setState(() {
        isresetting = true;
      });

      try {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('Users')
            .where('emailAddress', isEqualTo: emailN)
            .get();
        if (snapshot.docs.isEmpty) {
          Fluttertoast.showToast(
              msg: "User not found",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightcolor,
              textColor: darkcolor,
              fontSize: screenWidth * 0.037);
          setState(() {
            isresetting = false;
          });
        } else {
          var id = snapshot.docs.first.id;
          await FirebaseFirestore.instance.collection('Users').doc(id).update({
            "password": fpass1,
          }).then((value) async {
            Fluttertoast.showToast(
                msg: "Password has been reset. You can now login!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: darkcolor,
                textColor: Colors.white,
                fontSize: screenWidth * 0.037);
            setState(() {
              phase = 1;
              isresetting = false;
            });
          });
        }
      } catch (e) {
        setState(() {
          isresetting = false;
        });
        Fluttertoast.showToast(
            msg:
                "Failed to update password because of an error. Please try again later.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: darkcolor,
            textColor: Colors.white,
            fontSize: screenWidth * 0.037);
      }
    }
  }

  onCheckDuplicates(check, variable) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = check == "email"
          ? await FirebaseFirestore.instance
              .collection('Users')
              .where("emailAddress", isEqualTo: variable)
              .get()
          : await FirebaseFirestore.instance
              .collection('Users')
              .where("phoneNumber", isEqualTo: variable)
              .get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      if (docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  onGetToken(user) async {
    String token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      if (token != fcmToken) {
        token = fcmToken;
      }
    }).onError((err) {
      // Error getting token.
    });

    var rawToken = await onGetPreference("peerpool_user_token");

    if (token == null && rawToken != null) {
      var id = user['id'];
      await onSetPreference("peerpool_user_token", rawToken);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .update({"token": rawToken}).then((value) async {});
    } else {
      var id = user['id'];
      await onSetPreference("peerpool_user_token", token);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .update({"token": token}).then((value) async {});
    }
  }

  onVerifyToken() async {
    double screenWidth = returnScreenWidth(context);

    var fName = signupfirstname.text.trim();
    var lName = signupsurname.text.trim();
    var phone = signupphone.text.trim();
    var email =
        mode == "reset" ? forgotemail.text.trim() : signupemail.text.trim();
    var pass1 = signuppassword.text.trim();

    if (_loginverify.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any input fields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
      setState(() {
        isverifying = false;
      });
    } else {
      setState(() {
        isverifying = true;
      });

      var otpVerification = await onVerifyOTP(email, _loginverify.text);

      if (otpVerification == "error") {
        Fluttertoast.showToast(
            msg:
                "Failed to verify OTP because of an error. Please contact any administrator.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
        setState(() {
          isverifying = false;
        });
      } else if (otpVerification == "wrong") {
        Fluttertoast.showToast(
            msg:
                "Wrong OTP. Please enter the code which was sent to your email.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
        setState(() {
          isverifying = false;
        });
      } else {
        if (_timer != null) {
          setState(() {
            _timer.cancel();
          });
        }

        if (mode == "reset") {
          setState(() {
            isverifying = false;
            phase = 5;
          });
        } else {
          try {
            await FirebaseFirestore.instance.collection('Users').add({
              'firstName': fName,
              'lastName': lName,
              'phoneNumber': phone,
              'emailAddress': email,
              'password': pass1,
              'status': 'open',
              'dateofsignup': DateTime.now().toString(),
            }).then((ref) async {
              var docID = ref.id;
              var data = {
                'id': docID,
                'firstName': fName,
                'lastName': lName,
                'phoneNumber': phone,
                'emailAddress': email,
                'password': pass1,
                'status': 'open',
                'dateofsignup': DateTime.now().toString(),
              };

              var body = {...data, "id": docID};
              await onGetToken(body);
              await onSetPreference("peerpool_logged_user", json.encode(body));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            }).onError((error, stackTrace) {
              Fluttertoast.showToast(
                  msg: "There was an error signing up. Please try again later!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: lightcolor,
                  textColor: darkcolor,
                  fontSize: screenWidth * 0.037);
              setState(() {
                isverifying = false;
              });
            });
          } catch (e) {
            Fluttertoast.showToast(
                msg: "Encountered unknown error. Please try again later!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: lightcolor,
                textColor: darkcolor,
                fontSize: screenWidth * 0.037);
            setState(() {
              isverifying = false;
            });
          }
        }
      }
    }
  }

  onResendOTP(email) async {
    double screenWidth = returnScreenWidth(context);

    try {
      setState(() {
        isresending = true;
      });
      var otp = await onGenerateOTP();

      await FirebaseFirestore.instance
          .collection('Verification')
          .doc(email)
          .set({'email': email, "otp": otp}).then((ref) async {
        var response = await onSendOTP(email, otp);

        if (response.body.isNotEmpty && response.body == "OK") {
          setState(() {
            emailN = email;
            phase = 3;
            isresending = false;
          });
          startTimer();
        } else {
          Fluttertoast.showToast(
              msg: "Failed to send OTP email. Please try again!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightcolor,
              textColor: darkcolor,
              fontSize: screenWidth * 0.037);
          setState(() {
            isresending = false;
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to send OTP email. Please try again!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
      setState(() {
        isresending = false;
      });
    }
  }

  onSendEmail() async {
    double screenWidth = returnScreenWidth(context);

    var email = forgotemail.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter your email address",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
    } else {
      setState(() {
        isresending = true;
      });
      var dupliemail = await onCheckDuplicates("email", email);

      if (!dupliemail) {
        Fluttertoast.showToast(
            msg: "Your email address was not found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
        setState(() {
          isresending = false;
        });
      } else {
        var otp = await onGenerateOTP();

        await FirebaseFirestore.instance
            .collection('Verification')
            .doc(email)
            .set({'email': email, "otp": otp}).then((ref) async {
          var response = await onSendOTP(email, otp);

          if (response.body.isNotEmpty && response.body == "OK") {
            setState(() {
              emailN = email;
              phase = 3;
              mode = "reset";
              isresending = false;
              _loginverify.text = "";
            });
            startTimer();
          } else {
            Fluttertoast.showToast(
                msg: "Failed to send OTP email. Please try again!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: lightcolor,
                textColor: darkcolor,
                fontSize: screenWidth * 0.037);
            setState(() {
              isresending = false;
            });
          }
        });
      }
    }
  }

  onSignIn() async {
    double screenWidth = returnScreenWidth(context);

    var phone = loginnumber.text.trim();
    var pass = loginpassword.text.trim();
    if (phone.isEmpty || pass.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any textfields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
    } else {
      setState(() {
        signinloading = true;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('phoneNumber', isEqualTo: phone)
          .get();

      if (snapshot.docs.isEmpty) {
        Fluttertoast.showToast(
            msg: "User not found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
        setState(() {
          signinloading = false;
        });
      } else {
        List<QueryDocumentSnapshot> docs = snapshot.docs;
        var data = docs.first.data() as Map<String, dynamic>;
        var id = docs.first.id;

        if (data['status'] == "blocked") {
          Fluttertoast.showToast(
              msg:
                  "Your account is blocked. Please contact the administrator to get it unblocked.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightcolor,
              textColor: darkcolor,
              fontSize: screenWidth * 0.037);
          setState(() {
            signinloading = false;
          });
        } else if (data['password'] != null && data['password'] == pass) {
          var body = {...data, "id": id};
          await onGetToken(body);
          await onRemovePreference("peerpool_logged_user");
          await onSetPreference("peerpool_logged_user", json.encode(body));
          setState(() {
            signinloading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        } else {
          Fluttertoast.showToast(
              msg: "Wrong Password",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightcolor,
              textColor: darkcolor,
              fontSize: screenWidth * 0.037);
          setState(() {
            signinloading = false;
          });
        }
      }
    }
  }

  onGenerateOTP() {
    String otp = "";

    Random random = Random();

    for (int a = 0; a < 6; a++) {
      int randomNum = random.nextInt(9);
      otp += randomNum.toString();
    }

    return otp;
  }

  onSignUp() async {
    double screenWidth = returnScreenWidth(context);

    var fName = signupfirstname.text.trim();
    var lName = signupsurname.text.trim();
    var phone = signupphone.text.trim();
    var email = signupemail.text.trim();
    var pass1 = signuppassword.text.trim();
    var pass2 = signupconfirmpassword.text.trim();

    if (fName.isEmpty ||
        lName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        pass1.isEmpty ||
        pass2.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any textfields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
    } else if (pass1 != pass2) {
      Fluttertoast.showToast(
          msg:
              "Passwords are not the same. Please make sure your password matches",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
    } else {
      var emailValid = EmailValidator.validate(email);

      if (!phone.startsWith("+263") || phone.length < 11) {
        Fluttertoast.showToast(
            msg:
                "The phone number you entered is invalid. Please enter a correct phone number in the format +263XXXXXXXXX",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
      } else if (!emailValid) {
        Fluttertoast.showToast(
            msg:
                "The email address you entered is invalid. Please enter a correct email address.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
      } else {
        setState(() {
          signuploading = true;
        });

        var dupliemail = await onCheckDuplicates("email", email);
        var dupliphone = await onCheckDuplicates("phone", phone);
        if (dupliemail) {
          Fluttertoast.showToast(
              msg: "Duplicate email address detected. Please try another one.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightcolor,
              textColor: darkcolor,
              fontSize: screenWidth * 0.037);
          setState(() {
            signuploading = false;
          });
        } else if (dupliphone) {
          Fluttertoast.showToast(
              msg: "Duplicate phone detected. Please try another one.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: lightcolor,
              textColor: darkcolor,
              fontSize: screenWidth * 0.037);
          setState(() {
            signuploading = false;
          });
        } else {
          try {
            var otp = await onGenerateOTP();

            await FirebaseFirestore.instance
                .collection('Verification')
                .doc(email)
                .set({'email': email, "otp": otp}).then((ref) async {
              var response = await onSendOTP(email, otp);

              if (response.body.isNotEmpty && response.body == "OK") {
                setState(() {
                  _start = 60;
                  emailN = email;
                  phase = 3;
                  mode = "signup";
                });
                startTimer();
                setState(() {
                  signuploading = false;
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Failed to send OTP email. Please try again! 360815",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: lightcolor,
                    textColor: darkcolor,
                    fontSize: screenWidth * 0.037);
                setState(() {
                  signuploading = false;
                });
              }
            });
          } catch (e) {
            Fluttertoast.showToast(
                msg: "Encountered unknown error. Please try again later!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: lightcolor,
                textColor: darkcolor,
                fontSize: screenWidth * 0.037);
            setState(() {
              signuploading = false;
            });
          }
        }
      }
    }
  }

  buildForgotPasswordWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FadeIn(
        preferences:
            const AnimationPreferences(duration: Duration(milliseconds: 500)),
        child: Container(
          padding: EdgeInsets.only(top: screenHeight * 0.022),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Email Address Form Field
              Container(
                height: screenHeight * 0.077,
                width: screenWidth,
                margin: EdgeInsets.only(top: screenHeight * 0.015),
                decoration: BoxDecoration(
                    color: darkcolor, border: Border.all(color: Colors.white)),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: darkcolor,
                        border: const Border(
                            right: BorderSide(color: Colors.white))),
                    width: screenWidth * 0.15,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.email_outlined,
                      size: screenWidth * 0.075,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: forgotemail,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(
                      //       RegExp("[A-Za-z`'-._ ]*"))
                      // ],
                      cursorWidth: 1,
                      maxLength: 200,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      cursorColor: Colors.white,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontFamily: regularfont,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Enter Email Address",
                          counterText: "",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontFamily: regularfont,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: screenHeight * 0.047,
                              left: screenWidth * 0.03,
                              right: screenWidth * 0.03),
                          fillColor: darkcolor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.005),
                              borderSide:
                                  BorderSide(color: darkcolor, width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.01),
                              borderSide:
                                  BorderSide(color: darkcolor, width: 0))),
                    ),
                  ),
                ]),
              ),
              InkWell(
                onTap: () {
                  onSendEmail();
                },
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: screenHeight * 0.015),
                  color: lightcolor,
                  child: isresending
                      ? returnLoadingWidget(context, "dark")
                      : Text(
                          "Send Reset OTP",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.045,
                            fontFamily: boldfont,
                            color: darkcolor,
                          ),
                        ),
                ),
              ),
              //Sign Up Action Button
              InkWell(
                onTap: () {
                  setState(() {
                    phase = 1;
                  });
                },
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth,
                  alignment: Alignment.center,
                  color: darkcolor,
                  child: RichText(
                    text: TextSpan(
                      text: "Remember your password? ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: screenWidth * 0.038,
                        fontFamily: regularfont,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Back to login!',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.038,
                            fontFamily: regularfont,
                            color: lightcolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }

  buildResetPasswordWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FadeIn(
      preferences:
          const AnimationPreferences(duration: Duration(milliseconds: 500)),
      child: Container(
        padding: EdgeInsets.only(top: screenHeight * 0.022),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //New Password Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.lock,
                    size: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: forgotpassword1,
                    cursorWidth: 1,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: !showpassword,
                    obscuringCharacter: "#",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter New Password",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: showpassword
                                ? screenHeight * 0.047
                                : screenHeight * 0.005,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
                forgotpassword1.text.isEmpty
                    ? returnEmptyContainer()
                    : InkWell(
                        onTap: () {
                          onChangePasswordVisibility();
                        },
                        child: Container(
                          width: screenWidth * 0.1,
                          margin: EdgeInsets.only(right: screenWidth * 0.015),
                          alignment: Alignment.center,
                          child: Icon(
                            showpassword
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            size: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ]),
            ),

            //Confirm Password Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.lock,
                    size: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: forgotpassword2,
                    cursorWidth: 1,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: !showpassword,
                    obscuringCharacter: "#",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Confirm New Password",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: showpassword
                                ? screenHeight * 0.047
                                : screenHeight * 0.005,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
                forgotpassword2.text.isEmpty
                    ? returnEmptyContainer()
                    : InkWell(
                        onTap: () {
                          onChangePasswordVisibility();
                        },
                        child: Container(
                          width: screenWidth * 0.1,
                          margin: EdgeInsets.only(right: screenWidth * 0.015),
                          alignment: Alignment.center,
                          child: Icon(
                            showpassword
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            size: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ]),
            ),

            //Reset Action Button
            InkWell(
              onTap: () {
                onResetPassword();
              },
              child: Container(
                height: screenHeight * 0.07,
                width: screenWidth,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: screenHeight * 0.015),
                color: lightcolor,
                child: isresetting
                    ? returnLoadingWidget(context, "dark")
                    : Text(
                        "Reset Password",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.045,
                          fontFamily: boldfont,
                          color: darkcolor,
                        ),
                      ),
              ),
            ),

            InkWell(
              onTap: () {
                setState(() {
                  phase = 1;
                });
              },
              child: Container(
                height: screenHeight * 0.07,
                width: screenWidth,
                alignment: Alignment.center,
                color: darkcolor,
                child: RichText(
                  text: TextSpan(
                    text: "Failed to change? ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.038,
                      fontFamily: regularfont,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Return to login!',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.038,
                          fontFamily: regularfont,
                          color: lightcolor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  buildLoginWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FadeIn(
        preferences:
            const AnimationPreferences(duration: Duration(milliseconds: 500)),
        child: Container(
          padding: EdgeInsets.only(top: screenHeight * 0.022),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Phone Text Form Field
              Container(
                height: screenHeight * 0.077,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: darkcolor, border: Border.all(color: Colors.white)),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: darkcolor,
                        border: const Border(
                            right: BorderSide(color: Colors.white))),
                    width: screenWidth * 0.15,
                    alignment: Alignment.center,
                    child: Icon(
                      LineIcons.mobilePhone,
                      size: screenWidth * 0.075,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: loginnumber,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))
                      ],
                      cursorWidth: 1,
                      maxLength: 200,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      cursorColor: Colors.white,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontFamily: regularfont,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Enter Phone Number",
                          counterText: "",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontFamily: regularfont,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: screenHeight * 0.047,
                              left: screenWidth * 0.03,
                              right: screenWidth * 0.03),
                          fillColor: darkcolor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.005),
                              borderSide:
                                  BorderSide(color: darkcolor, width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.01),
                              borderSide:
                                  BorderSide(color: darkcolor, width: 0))),
                    ),
                  ),
                ]),
              ),

              //Password Form Field
              Container(
                height: screenHeight * 0.077,
                width: screenWidth,
                margin: EdgeInsets.only(top: screenHeight * 0.015),
                decoration: BoxDecoration(
                    color: darkcolor, border: Border.all(color: Colors.white)),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: darkcolor,
                        border: const Border(
                            right: BorderSide(color: Colors.white))),
                    width: screenWidth * 0.15,
                    alignment: Alignment.center,
                    child: Icon(
                      LineIcons.lock,
                      size: screenWidth * 0.07,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: loginpassword,
                      cursorWidth: 1,
                      maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      cursorColor: Colors.white,
                      textAlignVertical: TextAlignVertical.center,
                      obscureText: !showpassword,
                      obscuringCharacter: "#",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontFamily: regularfont,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Enter Password",
                          counterText: "",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontFamily: regularfont,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: showpassword
                                  ? screenHeight * 0.047
                                  : screenHeight * 0.005,
                              left: screenWidth * 0.03,
                              right: screenWidth * 0.03),
                          fillColor: darkcolor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.005),
                              borderSide:
                                  BorderSide(color: darkcolor, width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.01),
                              borderSide:
                                  BorderSide(color: darkcolor, width: 0))),
                    ),
                  ),
                  loginpassword.text.isEmpty
                      ? returnEmptyContainer()
                      : InkWell(
                          onTap: () {
                            onChangePasswordVisibility();
                          },
                          child: Container(
                            width: screenWidth * 0.1,
                            margin: EdgeInsets.only(right: screenWidth * 0.015),
                            alignment: Alignment.center,
                            child: Icon(
                              showpassword
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              size: screenWidth * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ]),
              ),

              //Sign Up Action Button
              InkWell(
                onTap: () {
                  onForgotPassword();
                },
                child: Container(
                    height: screenHeight * 0.05,
                    width: screenWidth,
                    alignment: Alignment.centerRight,
                    color: darkcolor,
                    child: Text("Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.038,
                          fontFamily: regularfont,
                          color: lightcolor,
                        ))),
              ),
              //Sign In Action Button
              InkWell(
                onTap: () {
                  onSignIn();
                },
                child: Container(
                    height: screenHeight * 0.07,
                    width: screenWidth,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: screenHeight * 0.015),
                    color: lightcolor,
                    child: signinloading
                        ? returnLoadingWidget(context, "dark")
                        : Text("Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: screenWidth * 0.045,
                              fontFamily: boldfont,
                              color: darkcolor,
                            ))),
              ),
              //Sign Up Action Button
              InkWell(
                onTap: () {
                  setState(() {
                    phase = 2;
                  });
                },
                child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth,
                  alignment: Alignment.center,
                  color: darkcolor,
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: screenWidth * 0.038,
                        fontFamily: regularfont,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Create an account!',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.038,
                            fontFamily: regularfont,
                            color: lightcolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }

  buildVerificationWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      textStyle: TextStyle(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.w600,
          color: Colors.white),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
      ),
    );

    final focusedPinTheme = PinTheme(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      textStyle: TextStyle(
          fontSize: screenWidth * 0.035,
          color: Colors.white,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: lightcolor),
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
      ),
    );

    return FadeIn(
      preferences:
          const AnimationPreferences(duration: Duration(milliseconds: 500)),
      child: Container(
        padding: EdgeInsets.only(top: screenHeight * 0.022),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Pinput Form Field
            Align(
                alignment: Alignment.center,
                child: Text("Verify Number",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: regularfont,
                        color: lightcolor,
                        fontSize: screenWidth * 0.05))),
            //Mobile Input Field
            Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 8),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                          top: screenHeight * 0.01),
                      child: InkWell(
                        onTap: () {
                          istimeoutover == true
                              ? setState(() {
                                  phase = mode == "reset" ? 4 : 2;
                                })
                              : null;
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text:
                                    "Please enter the verification code sent to $emailN ",
                                style: TextStyle(
                                    fontFamily: lightfont,
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.036)),
                            istimeoutover == true
                                ? TextSpan(
                                    text: "CHANGE",
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontFamily: regularfont,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.035))
                                : const TextSpan(text: ""),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                          top: screenHeight * 0.015),
                      child: Pinput(
                        length: verificationcode.isEmpty
                            ? 6
                            : verificationcode.length,
                        focusNode: _pinPutFocusNode,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        controller: _loginverify,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                      )),
                ])),
            BounceIn(
                preferences: const AnimationPreferences(
                    offset: Duration(milliseconds: 300)),
                child: InkWell(
                  onTap: () => {onVerifyToken()},
                  child: Container(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.9,
                    margin: EdgeInsets.only(top: screenHeight * 0.015),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lightcolor,
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.005),
                      ),
                      child: isverifying == true
                          ? SizedBox(
                              height: screenHeight * 0.02,
                              width: screenHeight * 0.02,
                              child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : Text(
                              "Confirm",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: regularfont,
                                  fontWeight: FontWeight.bold,
                                  color: darkcolor,
                                  fontSize: screenWidth * 0.04),
                            ),
                    ),
                  ),
                )),
            isresending == true
                ? Container(
                    height: screenHeight * 0.02,
                    width: screenHeight * 0.02,
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
                : InkWell(
                    onTap: () {
                      istimeoutover == true ? onResendOTP(emailN) : null;
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.03),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Didn't receive OTP?  ",
                                style: TextStyle(
                                    fontFamily: lightfont,
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.035)),
                            istimeoutover == true
                                ? TextSpan(
                                    text: "RESEND",
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontFamily: regularfont,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.035))
                                : TextSpan(
                                    text: "RESEND IN $_start",
                                    style: TextStyle(
                                        color: lightcolor,
                                        fontFamily: italicfont,
                                        fontWeight: FontWeight.normal,
                                        fontSize: screenWidth * 0.035)),
                          ]),
                        ),
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }

  buildSignUpWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FadeIn(
      preferences:
          const AnimationPreferences(duration: Duration(milliseconds: 500)),
      child: Container(
        padding: EdgeInsets.only(top: screenHeight * 0.022),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //First Name Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.userCircle,
                    size: screenWidth * 0.075,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: signupfirstname,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[A-Za-z`'-._ ]*"))
                    ],
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter First Name",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: screenHeight * 0.047,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
              ]),
            ),
            //Last Name Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.userCircle,
                    size: screenWidth * 0.075,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: signupsurname,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[A-Za-z`'-._ ]*"))
                    ],
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Last Name",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: screenHeight * 0.047,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
              ]),
            ),
            //Phone Text Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.mobilePhone,
                    size: screenWidth * 0.075,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: signupphone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))
                    ],
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Phone Number",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: screenHeight * 0.047,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
              ]),
            ),
            //Email Address Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.email_outlined,
                    size: screenWidth * 0.075,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: signupemail,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(
                    //       RegExp("[A-Za-z`'-._ ]*"))
                    // ],
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Email Address",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: screenHeight * 0.047,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
              ]),
            ),
            //Password Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.lock,
                    size: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: signuppassword,
                    cursorWidth: 1,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: !showpasswordsignup,
                    obscuringCharacter: "#",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Password",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: showpasswordsignup
                                ? screenHeight * 0.047
                                : screenHeight * 0.005,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
                signuppassword.text.isEmpty
                    ? returnEmptyContainer()
                    : InkWell(
                        onTap: () {
                          onChangePasswordVisibilitySignUp();
                        },
                        child: Container(
                          width: screenWidth * 0.1,
                          margin: EdgeInsets.only(right: screenWidth * 0.015),
                          alignment: Alignment.center,
                          child: Icon(
                            showpasswordsignup
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            size: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ]),
            ),

            //Confirm Password Form Field
            Container(
              height: screenHeight * 0.077,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              decoration: BoxDecoration(
                  color: darkcolor, border: Border.all(color: Colors.white)),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkcolor,
                      border:
                          const Border(right: BorderSide(color: Colors.white))),
                  width: screenWidth * 0.15,
                  alignment: Alignment.center,
                  child: Icon(
                    LineIcons.lock,
                    size: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: signupconfirmpassword,
                    cursorWidth: 1,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    obscureText: !showpasswordsignup,
                    obscuringCharacter: "#",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Confirm Password",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontFamily: regularfont,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: showpasswordsignup
                                ? screenHeight * 0.047
                                : screenHeight * 0.005,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03),
                        fillColor: darkcolor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.005),
                            borderSide: BorderSide(color: darkcolor, width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenHeight * 0.01),
                            borderSide:
                                BorderSide(color: darkcolor, width: 0))),
                  ),
                ),
                signupconfirmpassword.text.isEmpty
                    ? returnEmptyContainer()
                    : InkWell(
                        onTap: () {
                          onChangePasswordVisibilitySignUp();
                        },
                        child: Container(
                          width: screenWidth * 0.1,
                          margin: EdgeInsets.only(right: screenWidth * 0.015),
                          alignment: Alignment.center,
                          child: Icon(
                            showpasswordsignup
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            size: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ]),
            ),

            //Sign In Action Button
            InkWell(
              onTap: () {
                onSignUp();
              },
              child: Container(
                  height: screenHeight * 0.07,
                  width: screenWidth,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: screenHeight * 0.015),
                  color: lightcolor,
                  child: signuploading
                      ? returnLoadingWidget(context, "dark")
                      : Text("Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.045,
                            fontFamily: boldfont,
                            color: darkcolor,
                          ))),
            ),
            //Sign Up Action Button
            InkWell(
              onTap: () {
                setState(() {
                  phase = 1;
                });
              },
              child: Container(
                height: screenHeight * 0.07,
                width: screenWidth,
                alignment: Alignment.center,
                color: darkcolor,
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.038,
                      fontFamily: regularfont,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign In!',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.038,
                          fontFamily: regularfont,
                          color: lightcolor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return WillPopScope(
      onWillPop: () async => onBackPressed(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: darkcolor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            height: screenHeight,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  phase == 1
                      ? Flexible(child: buildLoginWidget())
                      : phase == 2
                          ? Flexible(child: buildSignUpWidget())
                          : phase == 3
                              ? Flexible(child: buildVerificationWidget())
                              : phase == 4
                                  ? Flexible(child: buildForgotPasswordWidget())
                                  : Flexible(child: buildResetPasswordWidget())
                ]),
          ),
        ),
      ),
    );
  }
}
