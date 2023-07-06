import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:peerpool/utils/on_sign_out.dart';

import '../config.dart';
import '../widgets/render_screen_height.dart';
import '../widgets/render_screen_width.dart';
import '../widgets/return_loading_widget.dart';
import '../widgets/shared_prefs.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();

  final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword1 = TextEditingController();
  final TextEditingController newpassword2 = TextEditingController();

  int phase = 1;
  bool editDetails = false;
  bool editPassword = false;
  bool showpasswordprofile = false;
  bool savedetailsloading = false;
  bool savepasswordloading = false;

  String profileHeading = "User Profile";

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Map user = {};

  @override
  void initState() {
    super.initState();
    onGetUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onBackPressed() {
    if (editDetails | editPassword) {
      setState(() {
        editDetails = false;
        editPassword = false;
        profileHeading = "User Profile";
      });
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

  onSaveDetails() async {
    double screenWidth = returnScreenWidth(context);

    var id = user['id'];

    var fname = firstname.text.trim();
    var lname = surname.text.trim();
    var phonenum = phone.text.trim();
    var emailadd = email.text.trim();

    if (fname.isEmpty ||
        lname.isEmpty ||
        phonenum.isEmpty ||
        emailadd.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any textfields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: darkcolor,
          textColor: Colors.white,
          fontSize: screenWidth * 0.037);
    }
    var emailValid = EmailValidator.validate(emailadd);

    if (!phonenum.startsWith("+263") || phonenum.length < 10) {
      Fluttertoast.showToast(
          msg:
              "The phone number you entered is invalid. Please enter a correct phone number in the format +27XXXXXXXXX",
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
        savedetailsloading = true;
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
          savedetailsloading = false;
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
          savedetailsloading = false;
        });
      } else {
        try {
          await FirebaseFirestore.instance.collection('Users').doc(id).update({
            "firstName": fname,
            'lastName': lname,
            'phoneNumber': phonenum,
            'emailAddress': emailadd
          }).then((value) async {
            var body = {
              "firstName": fname,
              'lastName': lname,
              'phoneNumber': phonenum,
              'emailAddress': emailadd
            };
            setState(() {
              user.addAll(body);
              savedetailsloading = false;
              editDetails = false;
              editPassword = false;
              profileHeading = "User Profile";
              firstname.text = "";
              surname.text = "";
              phone.text = "";
              email.text = "";
            });
            Fluttertoast.showToast(
                msg: "Successfully updated user profile",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: darkcolor,
                textColor: Colors.white,
                fontSize: screenWidth * 0.037);
            await onSetPreference('peerpool_logged_user', json.encode(user));
          }).onError((error, stackTrace) {
            setState(() {
              savedetailsloading = false;
            });
            Fluttertoast.showToast(
                msg: "Failed to update user profile. Please try again later.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: darkcolor,
                textColor: Colors.white,
                fontSize: screenWidth * 0.037);
          });
        } catch (e) {
          setState(() {
            savedetailsloading = false;
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
  }

  onSavePassword() async {
    double screenWidth = returnScreenWidth(context);

    var id = user['id'];
    var savedpass = user['password'].toString().trim();

    var oldpass = oldpassword.text.trim();
    var newpass1 = newpassword1.text.trim();
    var newpass2 = newpassword2.text.trim();

    if (oldpass.isEmpty || newpass1.isEmpty || newpass2.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any textfields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: darkcolor,
          textColor: Colors.white,
          fontSize: screenWidth * 0.037);
    } else if (oldpass != savedpass) {
      Fluttertoast.showToast(
          msg: "Old password is incorrect. Please enter a correct password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: darkcolor,
          textColor: Colors.white,
          fontSize: screenWidth * 0.037);
    } else if (newpass1 != newpass2) {
      Fluttertoast.showToast(
          msg:
              "New passwords are not the same. Please make sure your new password matches",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: darkcolor,
          textColor: Colors.white,
          fontSize: screenWidth * 0.037);
    } else {
      setState(() {
        savepasswordloading = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(id)
            .update({"password": newpass1}).then((value) async {
          setState(() {
            user['password'] = newpass1;
            savepasswordloading = false;
            editDetails = false;
            editPassword = false;
            profileHeading = "User Profile";
            oldpassword.text = "";
            newpassword1.text = "";
            newpassword2.text = "";
          });
          Fluttertoast.showToast(
              msg: "Successfully updated password",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: darkcolor,
              textColor: Colors.white,
              fontSize: screenWidth * 0.037);
          await onSetPreference('peerpool_logged_user', json.encode(user));
        }).onError((error, stackTrace) {
          setState(() {
            savepasswordloading = false;
          });
          Fluttertoast.showToast(
              msg: "Failed to update password. Please try again later.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: darkcolor,
              textColor: Colors.white,
              fontSize: screenWidth * 0.037);
        });
      } catch (e) {
        setState(() {
          savepasswordloading = false;
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

  onGetUser() async {
    var data = await onGetPreference('peerpool_logged_user');
    if (data != null) {
      var loggedUser = json.decode(data);
      setState(() {
        user = loggedUser;
      });
    }
  }

  buildEditProfileWidget() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      margin:
          EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.06),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/logo.png',
            height: screenWidth * 0.35,
            width: screenWidth * 0.35,
          ),
        ),
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(top: screenHeight * 0.05),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.userCircle,
                size: screenWidth * 0.075,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: firstname,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[A-Za-z`'-._ ]*"))
                ],
                cursorWidth: 1,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.045,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "First Name",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),

        //Last Name TextField
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(top: screenHeight * 0.015),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.userCircle,
                size: screenWidth * 0.075,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: surname,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[A-Za-z`'-._ ]*"))
                ],
                cursorWidth: 1,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.045,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Last Name",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),

        //Phone TextField
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(top: screenHeight * 0.015),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.mobilePhone,
                size: screenWidth * 0.075,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                cursorWidth: 1,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.045,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Phone Number",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),
        //Email TextField
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(top: screenHeight * 0.015),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.envelope,
                size: screenWidth * 0.075,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                // ],
                cursorWidth: 1,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.045,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Email Address",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),

        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(top: screenHeight * 0.01),
          child: InkWell(
            onTap: () {
              onSaveDetails();
            },
            child: Container(
              height: screenHeight * 0.055,
              width: screenWidth * 0.75,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: screenHeight * 0.005),
              decoration: BoxDecoration(
                  color: darkcolor,
                  border: Border.all(color: lightcolor),
                  borderRadius: BorderRadius.circular(screenHeight * 0.003)),
              child: savedetailsloading
                  ? returnLoadingWidget(context, "light")
                  : Text(
                      "Save Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        fontFamily: lightfont,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: InkWell(
              onTap: () {
                setState(() {
                  editDetails = false;
                  editPassword = false;
                });
              },
              child: Container(
                height: screenHeight * 0.055,
                width: screenWidth * 0.75,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: screenHeight * 0.005),
                decoration: BoxDecoration(
                    color: lightcolor,
                    border: Border.all(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(screenHeight * 0.003)),
                child: Text(
                  "Return To Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                    fontFamily: lightfont,
                    color: Colors.white,
                  ),
                ),
              ),
            ))
      ]),
    );
  }

  buildEditPasswordWidget() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      margin:
          EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.06),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/logo.png',
            height: screenWidth * 0.35,
            width: screenWidth * 0.35,
          ),
        ),
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(
            top: screenHeight * 0.05,
          ),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.userLock,
                size: screenWidth * 0.07,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: oldpassword,
                cursorWidth: 1,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                obscureText: !showpasswordprofile,
                obscuringCharacter: "#",
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.042,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Enter Your Old Password",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.042,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),
        //New Password TextField
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(top: screenHeight * 0.015),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.userLock,
                size: screenWidth * 0.075,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: newpassword1,
                cursorWidth: 1,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                obscureText: !showpasswordprofile,
                obscuringCharacter: "#",
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.045,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Enter Your New Password",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.042,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),
        //New Password TextField
        Container(
          height: screenHeight * 0.06,
          width: screenWidth,
          margin: EdgeInsets.only(top: screenHeight * 0.015),
          child: Row(children: [
            Container(
              width: screenWidth * 0.15,
              alignment: Alignment.center,
              child: Icon(
                LineIcons.userLock,
                size: screenWidth * 0.075,
                color: darkcolor,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: newpassword2,
                cursorWidth: 1,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: darkcolor,
                textAlignVertical: TextAlignVertical.center,
                obscureText: !showpasswordprofile,
                obscuringCharacter: "#",
                style: TextStyle(
                  color: darkcolor,
                  fontSize: screenWidth * 0.042,
                  fontFamily: regularfont,
                ),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Confirm Your New Password",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.042,
                      fontFamily: regularfont,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkcolor, width: 0))),
              ),
            ),
          ]),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(top: screenHeight * 0.01),
          child: InkWell(
            onTap: () {
              onSavePassword();
            },
            child: Container(
              height: screenHeight * 0.055,
              width: screenWidth * 0.76,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: screenHeight * 0.005),
              decoration: BoxDecoration(
                  color: darkcolor,
                  border: Border.all(color: lightcolor),
                  borderRadius: BorderRadius.circular(screenHeight * 0.003)),
              child: savepasswordloading
                  ? returnLoadingWidget(context, "light")
                  : Text(
                      "Save Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        fontFamily: lightfont,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: InkWell(
              onTap: () {
                setState(() {
                  editDetails = false;
                  editPassword = false;
                });
              },
              child: Container(
                height: screenHeight * 0.055,
                width: screenWidth * 0.76,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: screenHeight * 0.005),
                decoration: BoxDecoration(
                    color: lightcolor,
                    border: Border.all(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(screenHeight * 0.003)),
                child: Text(
                  "Return To Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                    fontFamily: lightfont,
                    color: Colors.white,
                  ),
                ),
              ),
            ))
      ]),
    );
  }

  returnProfileHeading(title, style) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return FadeInUp(
      preferences:
          const AnimationPreferences(duration: Duration(milliseconds: 200)),
      child: Padding(
        padding: EdgeInsets.only(
            top: screenHeight * 0.03,
            right: screenWidth * 0.05,
            left: screenWidth * 0.06),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: style == "normal"
              ? TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.04,
                  fontFamily: regularfont,
                  color: darkcolor,
                )
              : TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: screenWidth * 0.035,
                  fontFamily: italicfont,
                  color: darkcolor,
                ),
        ),
      ),
    );
  }

  buildShowProfileWidget() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return SizedBox(
      width: screenWidth,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.only(top: screenWidth * 0.015),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/logo.png',
            height: screenWidth * 0.27,
            width: screenWidth * 0.27,
          ),
        ),
        SlideInUp(
          preferences:
              const AnimationPreferences(duration: Duration(milliseconds: 200)),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Card(
              child: Column(children: [
                returnUserItem(context, "First Name:", "${user['firstName']}",
                    LineIcons.userCheck),
                returnUserItem(context, "Last Name:", "${user['lastName']}",
                    LineIcons.userCheck),
                returnUserItem(context, "Phone Number:",
                    "${user['phoneNumber']}", LineIcons.phone),
                returnUserItem(context, "Email Address:",
                    "${user['emailAddress']}", LineIcons.envelope),
                returnPasswordItem(
                    context, "Your Password", "########", LineIcons.userLock),
                Padding(padding: EdgeInsets.only(bottom: screenHeight * 0.045)),
                InkWell(
                  onTap: () {
                    setState(() {
                      editDetails = true;
                      profileHeading = "Edit Details";
                      firstname.text = user['firstName'];
                      surname.text = user['lastName'];
                      phone.text = user['phoneNumber'];
                      email.text = user['emailAddress'];
                    });
                  },
                  child: Container(
                      height: screenHeight * 0.06,
                      width: screenWidth,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: screenHeight * 0.002),
                      decoration: BoxDecoration(
                        color: darkcolor,
                        border: Border.all(color: Colors.grey[200]),
                      ),
                      child: Text("Edit Your Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                            fontFamily: lightfont,
                            color: Colors.white,
                          ))),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  returnUserItem(context, header, content, icon) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: screenHeight * 0.05),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      width: screenWidth,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.02, horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                border: Border.all(color: Colors.grey[100])),
            child: Icon(
              icon,
              size: screenWidth * 0.07,
              color: darkcolor,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: screenWidth * 0.03)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenHeight * 0.01,
                    vertical: screenWidth * 0.003),
                color: Colors.grey[100],
                child: Text(
                  header,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: screenWidth * 0.025,
                    fontFamily: lightfont,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.008, left: screenWidth * 0.015),
                child: Text(
                  content,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: screenWidth * 0.0375,
                    fontFamily: regularfont,
                    color: darkcolor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  returnPasswordItem(context, header, content, icon) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: screenHeight * 0.05),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      width: screenWidth,
      child: Row(children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.02, horizontal: screenWidth * 0.02),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              border: Border.all(color: Colors.grey[100])),
          child: Icon(
            icon,
            size: screenWidth * 0.07,
            color: darkcolor,
          ),
        ),
        Padding(padding: EdgeInsets.only(right: screenWidth * 0.03)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * 0.01,
                  vertical: screenWidth * 0.003),
              color: Colors.grey[100],
              child: Text(
                header,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.025,
                  fontFamily: lightfont,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.008, left: screenWidth * 0.015),
              child: Text(
                content,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.0375,
                  fontFamily: regularfont,
                  color: darkcolor,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            setState(() {
              editPassword = true;
              profileHeading = "Edit Password";
            });
          },
          child: Container(
            height: screenHeight * 0.04,
            width: screenWidth * 0.32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(screenHeight * 0.035)),
            child: Text("Edit Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.026,
                    fontFamily: lightfont,
                    color: Colors.black)),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: ZoomIn(
        preferences:
            const AnimationPreferences(duration: Duration(milliseconds: 200)),
        child: Container(
          padding: EdgeInsets.only(top: screenHeight * 0.022),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: editDetails
                ? buildEditProfileWidget()
                : editPassword
                    ? buildEditPasswordWidget()
                    : buildShowProfileWidget(),
          ),
        ),
      ),
    );
  }
}
