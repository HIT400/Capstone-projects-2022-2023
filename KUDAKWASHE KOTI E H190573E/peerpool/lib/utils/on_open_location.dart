import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

onOpenLocation(Map coordinates) async {
  String homeLat = coordinates['lat'];
  String homeLng = coordinates['lon'];

  String googleMapslocationUrl =
      "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

  final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
  Uri myUri = Uri.parse(encodedURl);

  if (await canLaunchUrl(myUri)) {
    await launchUrl(myUri);
  } else {
    Fluttertoast.showToast(
        msg: "Cannot open location! Please try again later.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: lightcolor,
        textColor: darkcolor,
        fontSize: 16);
  }
}
