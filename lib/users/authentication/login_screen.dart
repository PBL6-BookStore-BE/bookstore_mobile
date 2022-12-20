
import 'dart:convert';
import 'package:books_app/users/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:books_app/api_connection/api_connection.dart';

import '../fragments/dashboard_of_fragments.dart';
import '../model/user.dart';
import '../userPreferences/user_preferences.dart';

class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;


  loginUserNow() async
  {
    try
    {
      var res = await http.post(
          Uri.parse("https://localhost:7075/gateway/login"),
          body: jsonEncode({
            "email" : emailController.text.trim(),
            "password" : passwordController.text.trim()
          }),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json"
          }

      );

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if(resBodyOfLogin['isSuccess'] == true)
        {
          Fluttertoast.showToast(msg: "you are logged-in Successfully.");

          String email = resBodyOfLogin["email"].toString();
          String username = resBodyOfLogin["userName"].toString();

          //save userInfo to local Storage using Shared Prefrences
          await RememberUserPrefs.saveRememberUser(username, email);

          Future.delayed(Duration(milliseconds: 2000), ()
          {
            Get.to(DashboardOfFragments());
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Incorrect Credentials.\nPlease write correct password or email and Try Again.");
        }
      }

    }
    catch(e)
    {
      print("Error :: " + e.toString());
    }


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor:  Colors.black,
      body: LayoutBuilder(
        builder: (context,cons){
          return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child: Image.asset(
                      "images/login.jpg",
                    ),
                  ),
                  //login form

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),

                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0,-3),

                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30,30,30,8),
                        child: Column(
                          children: [

                            //email-password-login button
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) => val == ""? "Please write email" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "email...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),

                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),

                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),

                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),

                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,

                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                 const SizedBox(height: 18,),


                               Obx(() =>TextFormField(
                                 controller: passwordController,
                                 obscureText: isObsecure.value,
                                 validator: (val) => val == ""? "Please write password" : null,
                                 decoration: InputDecoration(
                                   prefixIcon: const Icon(
                                     Icons.vpn_key_sharp,
                                     color: Colors.black,
                                   ),
                                   suffixIcon: Obx(
                                           () => GestureDetector(
                                         onTap: ()
                                         {
                                           isObsecure.value  = ! isObsecure.value;
                                         },
                                         child: Icon(
                                           isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                           color: Colors.black,
                                         ),
                                       )
                                   ),


                                   hintText: "password...",
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(30),
                                     borderSide: const BorderSide(
                                       color: Colors.white60,
                                     ),

                                   ),
                                   enabledBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(30),
                                     borderSide: const BorderSide(
                                       color: Colors.white60,
                                     ),

                                   ),
                                   focusedBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(30),
                                     borderSide: const BorderSide(
                                       color: Colors.white60,
                                     ),

                                   ),
                                   disabledBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(30),
                                     borderSide: const BorderSide(
                                       color: Colors.white60,
                                     ),

                                   ),
                                   contentPadding: const EdgeInsets.symmetric(
                                     horizontal: 14,
                                     vertical: 6,

                                   ),
                                   fillColor: Colors.white,
                                   filled: true,
                                 ),
                               )),
                                  const SizedBox(height: 18,),


                                  //button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        if(formKey.currentState!.validate()) {
                                          loginUserNow();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 16,),
                            //Dont have an account button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an Account?"
                                ),
                                TextButton(
                                  onPressed: (){
                                    Get.to(SignUpScreen());
                                  },
                                  child: const Text(
                                    "SignUp Here",
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ) ,
            ),
          );
        },
      ),
    );
  }
}
