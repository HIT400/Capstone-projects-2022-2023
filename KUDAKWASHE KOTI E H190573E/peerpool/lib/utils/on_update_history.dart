import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/shared_prefs.dart';

onUpdateHistory(Map data) async {
  var hist = await onGetPreference('peerpool_auction_history');
  if (hist == null || hist == "") {
    List set = [];
    set.add(data);
    await onSetPreference('peerpool_auction_history', json.encode(set));
  } else {
    List set = [];
    List oldset = json.decode(hist);
    set.add(data);
    set.addAll(oldset);
    await onSetPreference('peerpool_auction_history', json.encode(set));
  }

  try {
    await FirebaseFirestore.instance
        .collection('History')
        .add(data)
        .then((value) async {});
  } catch (e) {}
}
