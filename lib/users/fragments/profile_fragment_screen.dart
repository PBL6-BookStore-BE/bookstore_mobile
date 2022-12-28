import 'dart:convert';

import 'package:books_app/users/authentication/login_screen.dart';
import 'package:books_app/users/userPreferences/current_user.dart';
import 'package:books_app/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileFragmentScreen extends StatelessWidget
{

  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async
  {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        ),
        content: const Text(
          "Are you sure?\nYou want to logout from app?"
        ),
        actions: [
          TextButton(
              onPressed: ()
              {
                Get.back();
              },
              child: const Text (
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
          TextButton(
              onPressed: ()
              {
                Get.back(result: "loggedOut");
              },
              child: const Text (
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
        ],
      ),
    );

    if(resultResponse == "loggedOut")
    {
      //delete-remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo()
          .then((value)
      {
        Get.off(LoginScreen());
      });
    }
  }

  // String? userName = "";
  // getUser() async
  // {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userName = (prefs.getString('currentUser')!! ?? "");
  // }
  Widget userInfoItemProfile(IconData iconData, String userData)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 16,),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // getUser();
    return ListView(

      padding: const EdgeInsets.all(32),
      children: [

        Center(
          child: Image.asset(
            "images/woman.png",
            width: 240
          )
        ),
        
        const SizedBox(height: 20,),

        userInfoItemProfile(Icons.person, _currentUser.user.username),

        const SizedBox(height: 20,),

        userInfoItemProfile(Icons.email, _currentUser.user.email),

        const SizedBox(height: 20,),

        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: ()
              {
                signOutUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        )



      ],
    );
  }
}
