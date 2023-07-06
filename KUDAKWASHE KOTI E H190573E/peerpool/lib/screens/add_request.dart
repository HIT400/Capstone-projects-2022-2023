import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:line_icons/line_icons.dart';
import 'package:peerpool/widgets/return_app_bar.dart';

import '../config.dart';
import '../widgets/render_screen_height.dart';
import '../widgets/render_screen_width.dart';
import '../widgets/return_loading_widget.dart';
import '../widgets/shared_prefs.dart';

class AddRequest extends StatefulWidget {
  const AddRequest({Key key}) : super(key: key);

  @override
  State<AddRequest> createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  final TextEditingController porigin = TextEditingController();
  final TextEditingController pdestination = TextEditingController();
  final TextEditingController pcardescription = TextEditingController();
  final TextEditingController pcarnumberplate = TextEditingController();
  final TextEditingController pcarmaxpeople = TextEditingController();
  String timeselected = "";
  String dateselected = "";

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isloading = false;
  bool isfetchingcoordinates = false;
  bool addrequestloading = false;

  Map user = {};
  Map coordinates = {};
  Map origincoordinates = {};
  Map destinationcoordinates = {};

  @override
  void initState() {
    onGetUser();
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

  onAddRequest() async {
    double screenWidth = returnScreenWidth(context);

    String startTime = timeselected;
    String destination = pdestination.text.trim();
    String numberPlate = pcarnumberplate.text.trim();
    String description = pcardescription.text.trim();

    if (startTime.isEmpty ||
        destination.isEmpty ||
        numberPlate.isEmpty ||
        description.isEmpty ||
        pcarmaxpeople.text.trim().isEmpty) {
      Fluttertoast.showToast(
          msg: "Please do not leave any textfields blank",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
    } else if (numberPlate.length < 4) {
      Fluttertoast.showToast(
          msg: "Your number plate is not correct",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: lightcolor,
          textColor: darkcolor,
          fontSize: screenWidth * 0.037);
    } else {
      setState(() {
        addrequestloading = true;
      });

      int maxpeople = int.parse(pcarmaxpeople.text.trim());

      await onGetCurrentCoordinates();
      if (coordinates.isEmpty) {
        Fluttertoast.showToast(
            msg:
                "Failed to get GPS coordinates. Please ensure your GPS is enabled!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: lightcolor,
            textColor: darkcolor,
            fontSize: screenWidth * 0.037);
        setState(() {
          addrequestloading = false;
        });
      } else {
        try {
          var revisedDate = "$dateselected $timeselected:00.000";

          await FirebaseFirestore.instance.collection('Requests').add({
            'requesterID': user['id'],
            'requesterName': user['firstName'] + " " + user['lastName'],
            'requesterEmail': user['emailAddress'],
            'requesterPhone': user['phoneNumber'],
            'requestDate': DateTime.now().toString(),
            'requestToken': user['token'],
            'coordinates': coordinates,
            'startDate': revisedDate,
            'destination': destination,
            'destinationCoordinates': destinationcoordinates,
            'numberPlate': numberPlate,
            'description': description,
            'maximumPeople': maxpeople
          }).then((ref) async {
            setState(() {
              addrequestloading = false;
            });
            Navigator.pop(context);
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(
                msg:
                    "There was an error adding your request. Please try again later!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: lightcolor,
                textColor: darkcolor,
                fontSize: screenWidth * 0.037);
            setState(() {
              addrequestloading = false;
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
            addrequestloading = false;
          });
        }
      }
    }
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

  returnPoolFields() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.015),
      child: Column(
        children: [
          SizedBox(
            width: screenWidth,
            child: Container(
              color: Colors.orange[600],
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.055),
              child: Text(
                "We will use your current GPS coordinates as part of this request",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.028,
                  fontFamily: lightfont,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          returnDateItem(),
          returnTimeItem(),
          Container(
            height: screenHeight * 0.077,
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: lightcolor)),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: lightcolor))),
                width: screenWidth * 0.15,
                alignment: Alignment.center,
                child: Icon(
                  LineIcons.carSide,
                  size: screenWidth * 0.075,
                  color: lightcolor,
                ),
              ),
              Expanded(
                child: GooglePlaceAutoCompleteTextField(
                    textEditingController: pdestination,
                    googleAPIKey: apiKey,
                    inputDecoration: InputDecoration(
                      filled: true,
                      hintText: "Destination (Where are you going?)",
                      counterText: "",
                      hintStyle: TextStyle(
                        color: darkcolor,
                        fontSize: screenWidth * 0.04,
                        fontFamily: lightfont,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: screenWidth * 0.03, right: screenWidth * 0.03),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                    debounceTime: 800,
                    countries: const ["zw"],
                    isLatLngRequired: true,
                    textStyle: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      setState(() {
                        destinationcoordinates = {
                          "lat": prediction.lat,
                          "lon": prediction.lng
                        };
                      });
                    },
                    itmClick: (Prediction prediction) {
                      pdestination.text = prediction.description;
                      pdestination.selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description.length));
                    }),
              )
            ]),
          ),
          Container(
            height: screenHeight * 0.077,
            width: screenWidth,
            margin: EdgeInsets.only(top: screenHeight * 0.01),
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: lightcolor)),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: lightcolor))),
                width: screenWidth * 0.15,
                alignment: Alignment.center,
                child: Icon(
                  LineIcons.carSide,
                  size: screenWidth * 0.075,
                  color: lightcolor,
                ),
              ),
              Expanded(
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: pcarnumberplate,
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: darkcolor,
                    style: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Car Number Plate (e.g - AAA000000)",
                      counterText: "",
                      hintStyle: TextStyle(
                        color: darkcolor,
                        fontSize: screenWidth * 0.04,
                        fontFamily: lightfont,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: screenWidth * 0.03, right: screenWidth * 0.03),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    )),
              ),
            ]),
          ),
          Container(
            height: screenHeight * 0.077,
            width: screenWidth,
            margin: EdgeInsets.only(top: screenHeight * 0.01),
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: lightcolor)),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: lightcolor))),
                width: screenWidth * 0.15,
                alignment: Alignment.center,
                child: Icon(
                  LineIcons.carSide,
                  size: screenWidth * 0.075,
                  color: lightcolor,
                ),
              ),
              Expanded(
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: pcardescription,
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: darkcolor,
                    style: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Car Description",
                      counterText: "",
                      hintStyle: TextStyle(
                        color: darkcolor,
                        fontSize: screenWidth * 0.04,
                        fontFamily: lightfont,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: screenWidth * 0.03, right: screenWidth * 0.03),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    )),
              ),
            ]),
          ),
          Container(
            height: screenHeight * 0.077,
            width: screenWidth,
            margin: EdgeInsets.only(top: screenHeight * 0.01),
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: lightcolor)),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: lightcolor))),
                width: screenWidth * 0.15,
                alignment: Alignment.center,
                child: Icon(
                  LineIcons.sortNumericUp,
                  size: screenWidth * 0.075,
                  color: lightcolor,
                ),
              ),
              Expanded(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: pcarmaxpeople,
                    cursorWidth: 1,
                    maxLength: 200,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    cursorColor: darkcolor,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    style: TextStyle(
                      color: darkcolor,
                      fontSize: screenWidth * 0.045,
                      fontFamily: regularfont,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Maximum People",
                      counterText: "",
                      hintStyle: TextStyle(
                        color: darkcolor,
                        fontSize: screenWidth * 0.04,
                        fontFamily: lightfont,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: screenWidth * 0.03, right: screenWidth * 0.03),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    )),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  returnDateItem() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      margin: EdgeInsets.only(top: screenHeight * 0.01),
      padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.02,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.02),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Start Date",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: lightfont,
                    color: darkcolor,
                    fontSize: screenWidth * 0.03)),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.002),
              child: Text(
                  dateselected.isEmpty ? "NO DATE SELECTED" : dateselected,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: boldfont,
                      color: lightcolor,
                      fontSize: dateselected.isEmpty
                          ? screenWidth * 0.035
                          : screenWidth * 0.05)),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            onShowDatePicker();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.011),
            decoration: BoxDecoration(
                color: lightcolor,
                border: Border.all(color: lightcolor),
                borderRadius:
                    BorderRadius.all(Radius.circular(screenHeight * 0.02))),
            alignment: Alignment.centerRight,
            child: Text("Select Start Date",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: lightfont,
                    color: Colors.white,
                    fontSize: screenWidth * 0.035)),
          ),
        ),
      ]),
    );
  }

  returnTimeItem() {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      margin: EdgeInsets.only(
          top: screenHeight * 0.01, bottom: screenHeight * 0.01),
      padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.02,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.02),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Start Time",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: lightfont,
                    color: darkcolor,
                    fontSize: screenWidth * 0.03)),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.002),
              child: Text(
                  timeselected.isEmpty ? "NO TIME SELECTED" : timeselected,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: boldfont,
                      color: lightcolor,
                      fontSize: timeselected.isEmpty
                          ? screenWidth * 0.035
                          : screenWidth * 0.05)),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            onShowTimePicker();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.011),
            decoration: BoxDecoration(
                color: lightcolor,
                border: Border.all(color: lightcolor),
                borderRadius:
                    BorderRadius.all(Radius.circular(screenHeight * 0.02))),
            alignment: Alignment.centerRight,
            child: Text("Select Start Time",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: lightfont,
                    color: Colors.white,
                    fontSize: screenWidth * 0.035)),
          ),
        ),
      ]),
    );
  }

  onShowDatePicker() async {
    var datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 5000)));
    if (datePicked != null) {
      setState(() {
        dateselected = datePicked.toString().split(" ")[0];
      });
    }
  }

  onShowTimePicker() async {
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    var timePicked =
        await showTimePicker(context: context, initialTime: timeOfDay);

    if (timePicked != null) {
      var selectedTime =
          "${timePicked.hour == 0 ? "00" : timePicked.hour < 10 ? "0${timePicked.hour}" : timePicked.hour}:${timePicked.minute == 0 ? "00" : timePicked.minute < 10 ? "0${timePicked.minute}" : timePicked.minute}";

      setState(() {
        timeselected = selectedTime.toString();
      });
    }
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
            context, "Add Pool Request", scaffoldKey, "add", onBackPressed),
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
                  children: [returnPoolFields()]),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            onAddRequest();
          },
          child: Container(
            height: screenHeight * 0.07,
            width: screenWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
                color: lightcolor,
                borderRadius: BorderRadius.circular(screenHeight * 0.035)),
            child: addrequestloading
                ? returnLoadingWidget(context, "dark")
                : Text(
                    "Add Request",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.045,
                      fontFamily: boldfont,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
