import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:peerpool/screens/add_request.dart';

import '../config.dart';
import '../utils/on_calculate_distance.dart';
import '../utils/on_contact.dart';
import '../utils/on_sign_out.dart';
import '../widgets/render_screen_height.dart';
import '../widgets/render_screen_width.dart';
import '../widgets/return_blocked_view.dart';
import '../widgets/return_empty_container.dart';
import '../widgets/return_error_widget.dart';
import '../widgets/return_loading_widget.dart';
import '../widgets/shared_prefs.dart';
import 'view_request.dart';

class RequestsHome extends StatefulWidget {
  const RequestsHome({Key key}) : super(key: key);

  @override
  State<RequestsHome> createState() => _RequestsHomeState();
}

class _RequestsHomeState extends State<RequestsHome> {
  bool isloading = false;
  bool isfetchingcoordinates = false;
  bool isrequestloading = false;

  Map user = {};
  Map coordinates = {};

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> requestStream;

  @override
  void initState() {
    onGetCurrentCoordinates();

    requestStream =
        FirebaseFirestore.instance.collection('Requests').snapshots();

    onFetchUser();
    onGetCurrentCoordinates();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onFetchUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('emailAddress', isEqualTo: "${user['emailAddress']}")
          .get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      var data = docs.first.data() as Map<String, dynamic>;
      var id = docs.first.id;
      var body = {...data, "id": id};

      await onRemovePreference("peerpool_logged_user");
      await onSetPreference("peerpool_logged_user", json.encode(body));
      await onGetUser();
    } catch (e) {
      await onGetUser();
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
      setState(() {
        coordinates = {
          'lat': coordinatesFetched.latitude.toString(),
          'lon': coordinatesFetched.longitude.toString()
        };
        isfetchingcoordinates = false;
      });
    }
  }

  returnCoordinates() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return SizedBox(
      width: screenWidth,
      child: Container(
        color: darkcolor,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02, horizontal: screenWidth * 0.055),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.005, bottom: screenHeight * 0.005),
                  child: RichText(
                    text: TextSpan(
                      text: "Current Coordinates: ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: screenWidth * 0.032,
                        fontFamily: lightfont,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: isfetchingcoordinates
                        ? "fetching..."
                        : coordinates.isEmpty
                            ? "Could not get current coordinates"
                            : "${coordinates['lat']},${coordinates['lon']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                      fontFamily: lightfont,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, top: screenHeight * 0.005),
              child: InkWell(
                onTap: () {
                  onGetCurrentCoordinates();
                },
                child: Text(
                  "REFRESH",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                    fontFamily: regularfont,
                    color: lightcolor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  returnRequestList() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);

    return StreamBuilder<QuerySnapshot>(
        stream: requestStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return returnErrorWidget(context, "Error Fetching Pool Requests",
                "There was an error fetching pool requests. Please reload this page.");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.2,
                child: returnLoadingWidget(context, 'dark'));
          }
          var initialIndex = 0;

          List<QueryDocumentSnapshot> docs =
              snapshot.data == null ? [] : snapshot.data.docs;

          if (docs.isEmpty) {
            return returnErrorWidget(context, "No Requests Found",
                "Requests you add will appear here after you have added them");
          } else {
            List<QueryDocumentSnapshot> requestsAdded;
            try {
              requestsAdded = docs.where((element) {
                Map<String, dynamic> opendata =
                    element.data() as Map<String, dynamic>;
                var time = opendata['startDate'];
                var date = DateTime.now();
                return date.isBefore(DateTime.parse(time));
              }).toList();
            } catch (e) {
              //Requests open
            }

            if (requestsAdded == null || requestsAdded.isEmpty) {
              return returnErrorWidget(context, "No Pool Requests Open",
                  "Pool requests still valid will appear here once they are added");
            } else {
              return SizedBox(
                width: screenWidth,
                child: ListView(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.025,
                      top: screenHeight * 0.01,
                      bottom: screenHeight * 0.1,
                      right: screenWidth * 0.025),
                  key: const Key("Request"),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children:
                      requestsAdded.map<Widget>((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    var id = document.id;
                    var requestItem = {...data, "id": id};
                    initialIndex += 1;

                    return returnRequestItem(requestItem, initialIndex);
                  }).toList(),
                ),
              );
            }
          }
        });
  }

  onRequestSelected(item) async {
    await onSetPreference('peerpool_selected_request', json.encode(item));
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ViewRequest()));
  }

  returnRequestItem(item, index) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);

    String distance = '';

    if (coordinates.isNotEmpty) {
      distance = onCalculateDistance(
          double.parse(item['coordinates']['lat']),
          double.parse(item['coordinates']['lon']),
          double.parse(coordinates['lat']),
          double.parse(coordinates['lon']));
    }

    List waitingList = item['waitingList'];

    return InkWell(
      onTap: () {
        onRequestSelected(item);
      },
      child: Container(
        width: screenWidth,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02),
        child: Card(
          elevation: 0,
          child: Stack(children: [
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  border: Border.all(color: darkcolor, width: 0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.005)),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.075,
                  vertical: screenHeight * 0.015),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.5,
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.01,
                        left: screenWidth * 0.01,
                      ),
                      child: Text("${item['destination']}",
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                            fontFamily: lightfont,
                            color: darkcolor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.007,
                        left: screenWidth * 0.01,
                      ),
                      child: Text("Request By: ${item['requesterName']}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.037,
                            fontFamily: lightfont,
                            color: darkcolor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.007,
                        left: screenWidth * 0.01,
                      ),
                      child: Text(
                          "Request Cell: ${item['requesterPhone'].toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.037,
                            fontFamily: lightfont,
                            color: darkcolor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.005,
                        left: screenWidth * 0.01,
                        bottom: screenHeight * 0.06,
                      ),
                      child: Text(
                          distance.isEmpty
                              ? "calculating"
                              : distance.length > 3
                                  ? "${double.parse(distance.toString())} KM AWAY"
                                  : "$distance KM AWAY",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenWidth * 0.035,
                            fontFamily: lightfont,
                            color: Colors.amber[800],
                          )),
                    ),
                  ]),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(color: darkcolor),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                ),
                child: Text(
                  "THIS RIDE IS STARTING on ${DateFormat.yMMMEd().format(DateTime.parse(item['startDate'])).toString()} at ${DateFormat.Hms().format(DateTime.parse(item['startDate'])).toString()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.027,
                    fontFamily: lightfont,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.01,
              right: screenWidth * 0.04,
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  left: screenWidth * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.005),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Text(
                        waitingList == null
                            ? "0 of ${item['maximumPeople']} people"
                            : "${waitingList.length} of ${item['maximumPeople']} people",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.033,
                          fontFamily: distance.isEmpty ? italicfont : lightfont,
                          color: darkcolor,
                        ),
                      ),
                    ),
                  ],
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
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
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
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  user['status'] == "blocked"
                      ? returnBlockedView(context, onContact(user))
                      : returnCoordinates(),
                  returnRequestList()
                ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "heroHome",
          backgroundColor: darkcolor,
          onPressed: () {
            onSignout(context);
          },
          child: Icon(LineIcons.powerOff,
              size: screenWidth * 0.08, color: Colors.white),
        ),
      ),
    );
  }
}
