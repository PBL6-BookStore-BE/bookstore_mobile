



import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs
{
  //save-remember User-info
  static Future<void> saveRememberUser(String username, String email) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData =
        jsonEncode({
          "email" : email,
          "username" : username
        });

    await preferences.setString("currentUser", userJsonData);
  }
}