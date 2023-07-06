import 'dart:convert';

import '../config.dart';

import 'package:http/http.dart' as http;

onSendNotification(token, message, title) async {
  var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

  var body = {
    "to": token,
    "priority": "high",
    "collapse_key": "type_a",
    "notification": {"body": message, "title": title},
    "data": {"body": message, "title": title, "key_1": "Message Data"}
  };

  try {
    var response = await http.post(url,
        headers: {
          "Authorization": "key=$serverKey",
          "Content-Type": "application/json"
        },
        body: json.encode(body));
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
  } catch (e) {
    //cannot send notification
  }
}
