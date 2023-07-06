import 'package:cloud_firestore/cloud_firestore.dart';

onVerifyOTP(email, otp) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Verification')
        .where('email', isEqualTo: email)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;

    if (docs != null && docs.isNotEmpty) {
      var data = docs.first.data() as Map<String, dynamic>;
      var correctOTP = data['otp'];
      if (otp == correctOTP) {
        return "correct";
      } else {
        return "wrong";
      }
    } else {
      return "error";
    }
  } catch (e) {
    return "error";
  }
}
