import 'package:shared_preferences/shared_preferences.dart';

onGetPreference(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String result = prefs.getString('$key');
  return result;
}

onSetPreference(key, value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('$key', value);
}

onRemovePreference(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('$key');
}
