import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'widgets/shared_prefs.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try {
    await Firebase.initializeApp().then((value) => {
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError
        });
  } catch (e) {}

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const MyHomePage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    onGetTrackingConfirmation();
    onStart();
    super.initState();
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
        //failed to process tracking request
      }
    }
  }

  onStart() async {
    String userDetails = await onGetPreference('peerpool_logged_user');

    if (userDetails == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
      FlutterNativeSplash.remove();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
