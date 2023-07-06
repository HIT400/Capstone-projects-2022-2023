import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../widgets/shared_prefs.dart';

onSignout(context) async {
  //other sign out logic
  await onRemovePreference('peerpool_logged_user');
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Login()));
}
