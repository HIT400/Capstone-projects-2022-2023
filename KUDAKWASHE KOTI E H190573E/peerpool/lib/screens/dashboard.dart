import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:peerpool/screens/my_request.dart';
import 'package:peerpool/screens/requests_home.dart';
import 'package:peerpool/screens/sent_requests.dart';

import '../config.dart';
import '../widgets/render_screen_height.dart';
import '../widgets/render_screen_width.dart';
import '../widgets/render_text_size.dart';
import 'add_request.dart';
import 'view_profile.dart';
import 'view_request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Dashboard(),
        '/add_request': (context) => const AddRequest(),
        '/view_request': (context) => const ViewRequest(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  double gap = 5;

  final List<Widget> pages = [
    const RequestsHome(
      key: PageStorageKey('Home'),
    ),
    const MyRequests(
      key: PageStorageKey('MyRequests'),
    ),
    const SentRequest(
      key: PageStorageKey('Sent Requests'),
    ),
    const ViewProfile(
      key: PageStorageKey('My Profile'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    onGetTrackingConfirmation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onGetTrackingConfirmation() async {
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      try {
        await AppTrackingTransparency.requestTrackingAuthorization();
      } catch (e, s) {
        //Failed to get token
      }
    }
  }

  onBackPressed() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = returnScreenWidth(context);
    double screenHeight = returnScreenHeight(context);
    var padding = EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02);

    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          child: IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: lightcolor,
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  color: darkcolor.withOpacity(.5),
                  offset: const Offset(15, 15),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.3, vertical: 0.3),
              child: GNav(
                tabs: [
                  GButton(
                    gap: gap,
                    iconActiveColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: darkcolor.withOpacity(.5),
                    iconSize: returnFontSize(context, 0.06),
                    padding: padding,
                    icon: LineIcons.car,
                    text: 'Home',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: returnFontSize(context, 0.032),
                        fontFamily: boldfont),
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: darkcolor.withOpacity(.5),
                    iconSize: returnFontSize(context, 0.06),
                    padding: padding,
                    icon: LineIcons.alternateCloudDownload,
                    text: 'My Requests',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: returnFontSize(context, 0.032),
                        fontFamily: boldfont),
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: darkcolor.withOpacity(.5),
                    iconSize: returnFontSize(context, 0.06),
                    padding: padding,
                    icon: LineIcons.carSide,
                    text: 'Sent Requests',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: returnFontSize(context, 0.032),
                        fontFamily: boldfont),
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: darkcolor.withOpacity(.5),
                    iconSize: returnFontSize(context, 0.06),
                    padding: padding,
                    icon: LineIcons.userCircle,
                    text: 'My Profile',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: returnFontSize(context, 0.032),
                        fontFamily: boldfont),
                  ),
                ],
                selectedIndex: selectedIndex,
                curve: Curves.easeInCubic,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
