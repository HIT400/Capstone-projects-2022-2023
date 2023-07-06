import 'dart:convert';

import 'package:http/http.dart' as http;

onSendOTP(email, otp) async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
    url,
    headers: {'origin': 'http://localhost', 'Content-Type': "application/json"},
    body: json.encode({
      "service_id": "service_jnijlrt",
      "template_id": "template_7i0mv8e",
      "user_id": "6dA0cFCd_nSOByLT4",
      "template_params": {
        "otp_code": otp,
        "send_to": email,
        "reply_to": "mufungogeeks@gmail.com"
      }
    }),
  );

  return response;
}
