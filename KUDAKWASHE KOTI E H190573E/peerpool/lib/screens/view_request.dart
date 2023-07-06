// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:peerpool/screens/dashboard.dart';
import 'package:peerpool/utils/on_send_notification.dart';
import 'package:peerpool/widgets/return_empty_container.dart';

import '../config.dart';
import '../utils/on_call_person.dart';
import '../utils/on_open_location.dart';
import '../widgets/render_screen_height.dart';
import '../widgets/render_screen_width.dart';
import '../widgets/return_app_bar.dart';
import '../widgets/return_loading_widget.dart';
import '../widgets/shared_prefs.dart';

class ViewRequest extends StatefulWidget {
  const ViewRequest({Key key}) : super(key: key);

  @override
  State<ViewRequest> createState() => _ViewRequestState();
}

class _ViewRequestState extends State<ViewRequest> {
  final TextEditingController askercomment = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isloading = false;
  bool askloading = false;
  bool locationloading = false;
  bool listloading = false;

  bool isfetchingcoordinates = false;
  List currentWaitingList = [];

  Map user = {};
  Map request = {};
  Map coordinates = {};

  @override
  void initState() {
    onGetUser();
    onGetRequest();
    onGetCurrentCoordinates();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onBackPressed() {
    Navigator.pop(context);
  }

  onGetRequest() async {
    var data = await onGetPreference('peerpool_selected_request');
    if (data != null) {
      var selectedRequest = json.decode(data);

      setState(() {
        request = selectedRequest;
        if (request['waitingList'] != null) {
          currentWaitingList = request['waitingList'];
        }
      });

      await onGetCurrentWaitingList();
    }
  }

  onGetUser() async {
    var data = await onGetPreference('peerpool_logged_user');
    var tdata = await onGetPreference('peerpool_user_token');

    if (data != null) {
      var loggedUser = json.decode(data);
      setState(() {
        user = loggedUser;
      });

      if (tdata != null) {
        setState(() {
          user['token'] = tdata;
        });
      }
    }

    setState(() {
      isloading = false;
    });
  }

  onGetCurrentCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      isfetchingcoordinates = true;
    });

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: "Location services are disabled!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: 16);
      setState(() {
        isfetchingcoordinates = false;
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Location services are denied!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: 16);
        setState(() {
          isfetchingcoordinates = false;
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              "Location permissions are permanently denied, we cannot request permissions!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: 16);
      setState(() {
        isfetchingcoordinates = false;
      });
    }

    var coordinatesFetched = await Geolocator.getCurrentPosition();
    if (coordinatesFetched != null) {
      if (mounted) {
        setState(() {
          coordinates = {
            'lat': coordinatesFetched.latitude.toString(),
            'lon': coordinatesFetched.longitude.toString()
          };
          isfetchingcoordinates = false;
        });
      }
    }
  }

  onGetCurrentWaitingList() async {
    setState(() {
      listloading = true;
    });
    try {
      var id = request['id'];
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Requests').doc(id).get();

      if (snapshot.exists) {
        var data = snapshot.data();
        var waitingList = data['waitingList'];
        setState(() {
          currentWaitingList = waitingList;
          listloading = false;
        });
      } else {
        setState(() {
          currentWaitingList = [];
          listloading = false;
        });
      }
    } catch (e) {
      setState(() {
        listloading = false;
      });
    }
  }

  onRequestRide() async {
    setState(() {
      askloading = true;
    });
    await onGetCurrentWaitingList();

    var id = request['id'];

    List waitingList = [];

    Map body = {
      'personID': user['id'],
      'personName': user['firstName'] + " " + user['lastName'],
      'personPhone': user['phoneNumber'],
      'personEmail': user['emailAddress'],
      'personToken': user['token'],
      'comment': askercomment.text.trim(),
      'coordinates': coordinates
    };

    if (currentWaitingList == null) {
      waitingList.add(body);
    } else {
      currentWaitingList.add(body);
      waitingList = currentWaitingList;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(id)
          .update({"waitingList": waitingList}).then((value) async {
        await onSendNotification(
            request['requestToken'],
            "${user['firstName']} ${user['lastName']} has requested for a ride. Open the app to check the details",
            "A user has requested a ride");
        setState(() {
          askloading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      });
    } catch (e) {
      setState(() {
        askloading = false;
      });
      Fluttertoast.showToast(
          msg: "Failed to update waiting list. Please try again later!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: darkcolor,
          textColor: Colors.white,
          fontSize: 13);
    }
  }

  returnRequestView() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);

    return SlideInUp(
      preferences:
          const AnimationPreferences(duration: Duration(milliseconds: 200)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenWidth * 0.05),
        child: Card(
          child: request.isEmpty
              ? returnEmptyContainer()
              : Column(children: [
                  returnRequestItem(
                      context, "${request['destination']}", LineIcons.globe),
                  returnRequestItem(
                      context,
                      DateFormat.yMMMEd()
                          .format(DateTime.parse(request['startDate']))
                          .toString(),
                      LineIcons.calendar),
                  returnRequestItem(
                      context,
                      DateFormat.Hm()
                          .format(DateTime.parse(request['startDate']))
                          .toString(),
                      LineIcons.calendar),
                  returnRequesterView(),
                  returnRequestItem(
                      context, "${request['description']}", LineIcons.car),
                  returnRequestItem(
                      context, "${request['numberPlate']}", LineIcons.car),
                  returnRequestItem(
                      context,
                      "${request['maximumPeople']} people wanted",
                      LineIcons.car),
                  returnRequestItem(
                      context,
                      listloading
                          ? "loading list"
                          : "${currentWaitingList == null ? 0 : currentWaitingList.length} people are on the waiting list",
                      Icons.people_outlined),
                  request['requesterEmail'] == user['emailAddress']
                      ? Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.02),
                          child: const Divider(
                            height: 1,
                            thickness: 1,
                          ),
                        )
                      : returnEmptyContainer(),
                  request['requesterEmail'] == user['emailAddress']
                      ? returnWaitingList(request['waitingList'])
                      : returnEmptyContainer(),
                  request['requesterEmail'] == user['emailAddress']
                      ? returnEmptyContainer()
                      : InkWell(
                          onTap: () {
                            setState(() {
                              locationloading = true;
                            });
                            onOpenLocation(request['coordinates']);
                            setState(() {
                              locationloading = false;
                            });
                          },
                          child: Container(
                            height: screenHeight * 0.055,
                            width: screenWidth,
                            margin: EdgeInsets.only(top: screenHeight * 0.015),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange[800],
                                borderRadius: BorderRadius.circular(
                                    screenHeight * 0.002)),
                            child: locationloading
                                ? returnLoadingWidget(context, "dark")
                                : Text(
                                    "Open Location In Map",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.045,
                                      fontFamily: lightfont,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                ]),
        ),
      ),
    );
  }

  returnWaitingList(waitingList) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    if (waitingList == null) {
      return returnEmptyContainer();
    } else {
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: screenHeight * 0.02),
        child: request.isEmpty
            ? returnEmptyContainer()
            : Column(children: [
                ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.2,
                  ),
                  itemCount: waitingList.length,
                  key: const Key("pList"),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int index) {
                    var personItem = waitingList[index];
                    return returnWaitingListItem(personItem, index);
                  },
                ),
              ]),
      );
    }
  }

  returnWaitingListItem(person, index) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      alignment: Alignment.center,
      width: screenWidth,
      height: screenHeight * 0.05,
      margin: EdgeInsets.only(top: screenHeight * 0.015),
      child: ListTile(
        dense: true,
        leading: SizedBox(
          width: screenWidth * 0.5,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person['personName'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                    fontFamily: lightfont,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.005),
                  child: Text(
                    person['comments'] == null || person['comments'] == ''
                        ? "No Comments"
                        : person['comments'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.033,
                      fontFamily: lightfont,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        trailing: SizedBox(
            width: screenWidth * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (() => onCallPerson(person['personPhone'])),
                  child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.02),
                    child: Icon(
                      CupertinoIcons.phone_circle,
                      size: screenWidth * 0.065,
                      color: darkcolor,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() async {
                    onOpenLocation(person['coordinates']);
                    await onSendNotification(
                        person['personToken'],
                        "A driver has accessed your location. Open the app to check the details",
                        "A driver has accessed your location");
                  }),
                  child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.02),
                    child: Icon(
                      CupertinoIcons.location_circle,
                      size: screenWidth * 0.065,
                      color: darkcolor,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  returnRequesterView() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);

    return Container(
      alignment: Alignment.center,
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02, horizontal: screenWidth * 0.009),
      width: screenWidth,
      child: Row(children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.03, right: screenWidth * 0.04),
          child: Icon(
            LineIcons.userCircle,
            size: screenWidth * 0.06,
            color: darkcolor,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: " + request['requesterName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.035,
                fontFamily: lightfont,
                color: darkcolor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.005),
              child: Text(
                "Phone: " + request['requesterPhone'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.035,
                  fontFamily: lightfont,
                  color: darkcolor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.005),
              child: Text(
                "Email: " + request['requesterEmail'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.035,
                  fontFamily: lightfont,
                  color: darkcolor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.005),
              child: Text(
                "Date of Request: " +
                    DateFormat.yMMMEd()
                        .format(DateTime.parse(request['requestDate']))
                        .toString(),
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.035,
                  fontFamily: lightfont,
                  color: darkcolor,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  returnRequestItem(context, title, icon) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      alignment: Alignment.center,
      width: screenWidth,
      child: ListTile(
        dense: true,
        leading: SizedBox(
          width: screenWidth * 0.75,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.05),
                  child: Icon(
                    icon,
                    size: screenWidth * 0.06,
                    color: darkcolor,
                  ),
                ),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                      fontFamily: lightfont,
                      color: darkcolor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: returnAppbar(
            context, "View Pool Request", scaffoldKey, "add", onBackPressed),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: isloading
              ? Container(
                  height: screenHeight * 0.9,
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.25,
                          child: returnLoadingWidget(context, "dark"),
                        )
                      ]),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      returnRequestView(),
                    ]),
        ),
        bottomNavigationBar: Container(
          height: request['requesterEmail'] == user['emailAddress']
              ? 0
              : screenHeight * 0.2,
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              request['maximumPeople'] == null
                  ? returnEmptyContainer()
                  : currentWaitingList != null &&
                          currentWaitingList.length >=
                              int.parse(request['maximumPeople'].toString())
                      ? returnEmptyContainer()
                      : currentWaitingList != null &&
                              currentWaitingList
                                  .where((element) =>
                                      element['personEmail'] ==
                                      user['emailAddress'])
                                  .toList()
                                  .isNotEmpty
                          ? returnEmptyContainer()
                          : request['requesterEmail'] == user['emailAddress']
                              ? returnEmptyContainer()
                              : FadeIn(
                                  preferences: const AnimationPreferences(
                                      duration: Duration(milliseconds: 200)),
                                  child: Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.only(
                                        top: screenHeight * 0.015,
                                        bottom: screenHeight * 0.015),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: screenHeight * 0.045,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey[400])),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: askercomment,
                                                    cursorWidth: 1,
                                                    maxLength: 200,
                                                    maxLengthEnforcement:
                                                        MaxLengthEnforcement
                                                            .enforced,
                                                    cursorColor: darkcolor,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    style: TextStyle(
                                                      color: darkcolor,
                                                      fontSize:
                                                          screenWidth * 0.045,
                                                      fontFamily: regularfont,
                                                    ),
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      hintText: "Any Comments",
                                                      counterText: "",
                                                      hintStyle: TextStyle(
                                                        color: darkcolor,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                        fontFamily: lightfont,
                                                      ),
                                                      fillColor: Colors.white,
                                                      border: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  lightcolor)),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          lightcolor)),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          lightcolor)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
              currentWaitingList != null &&
                      currentWaitingList
                          .where((element) =>
                              element['personEmail'] == user['emailAddress'])
                          .toList()
                          .isNotEmpty
                  ? returnEmptyContainer()
                  : request['requesterEmail'] == user['emailAddress']
                      ? returnEmptyContainer()
                      : InkWell(
                          onTap: () {
                            onRequestRide();
                          },
                          child: Container(
                            height: screenHeight * 0.055,
                            width: screenWidth,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: request['maximumPeople'] == null
                                    ? lightcolor
                                    : currentWaitingList != null &&
                                            currentWaitingList.length >=
                                                int.parse(
                                                    request['maximumPeople']
                                                        .toString())
                                        ? Colors.grey[600]
                                        : lightcolor,
                                borderRadius: BorderRadius.circular(
                                    screenHeight * 0.002)),
                            child: askloading
                                ? returnLoadingWidget(context, "dark")
                                : Text(
                                    request['maximumPeople'] == null
                                        ? "Ask For A Ride"
                                        : currentWaitingList != null &&
                                                currentWaitingList.length >=
                                                    int.parse(
                                                        request['maximumPeople']
                                                            .toString())
                                            ? "This ride is full"
                                            : "Ask For A Ride",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: screenWidth * 0.045,
                                      fontFamily: boldfont,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
