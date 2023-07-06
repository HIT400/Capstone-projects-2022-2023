import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

onCallPerson(phone) async {
  final String encodedURl = Uri.encodeFull("tel://$phone");
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
