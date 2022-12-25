import 'dart:convert';

import 'package:books_app/users/model/books.dart';
import 'package:books_app/users/model/order.dart';
import 'package:books_app/users/order/order_details.dart';
import 'package:books_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderFragmentScreen extends StatelessWidget {

  final currentOnlineUser = Get.put(CurrentUser());
  List<Books> allBookItemsList = [];

  Future<List<OrderDisplay>> getCurrentUserOrderList() async
  {
      List<OrderDisplay> orderListOfCurrentUser = [];

      try
      {
        String token = currentOnlineUser.user.token;
        String idUser = currentOnlineUser.user.id;
        
        var res = await http.get(
          Uri.parse("https://localhost:7075/gateway/order/getordersbyuser").replace(queryParameters: {
            "id": idUser,
          }),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json",
            'Authorization': 'Bearer $token',
          },
        );

        if(res.statusCode == 200)
          {
            var responseBodyOfGetCurrentUserOrders = jsonDecode(res.body);

            (responseBodyOfGetCurrentUserOrders as List).forEach((eachCurrentUserOrderData)
            {
              orderListOfCurrentUser.add(OrderDisplay.fromJson(eachCurrentUserOrderData));
            });
          }
        else
          {
            Fluttertoast.showToast(msg: "Status Code is not 200");
          }
      }
      catch(errorMsg)
      {
        Fluttertoast.showToast(msg: "Error: " + errorMsg.toString());
      }

      try
      {
        var res = await http.get(
            Uri.parse("https://localhost:7075/gateway/books")
        );

        if(res.statusCode == 200)
        {
          var responseBodyOfTrending = jsonDecode(res.body);
          (responseBodyOfTrending as List).forEach((eachRecord)
          {
            allBookItemsList.add(Books.fromJson(eachRecord));
          });

        }
        else
        {
          Fluttertoast.showToast(msg: "Error, status code is not 200");
        }
      }
      catch(errorMsg)
      {
        print("Error:: " + errorMsg.toString());
      }

      return orderListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //order icon image + my orders
                Column(
                  children: [
                    Image.asset(
                      "images/orders_icon.png",
                      width: 140,
                    ),
                    const Text(
                      "My Orders",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                //history icon image + history
                GestureDetector(
                  onTap: ()
                  {
                    //send user to orders history screen
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "images/history_icon.png",
                          width: 45,
                        ),
                        const Text(
                          "History",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //some info
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Here are your successfully placed orders.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          //displaying the user orderList
          Expanded(
              child: displayOrderList(context),
          ),
          // displayOrderList(context)
        ],
      )
    );
  }

  Widget displayOrderList(context)
  {
    return FutureBuilder(
      future: getCurrentUserOrderList(),
      builder: (context, AsyncSnapshot<List<OrderDisplay>> dataSnapshot)
      {
        if(dataSnapshot.connectionState == ConnectionState.waiting)
        {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Connection Waiting...",
                    style: TextStyle(color: Colors.grey,),
                ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
        }
        if(dataSnapshot.data == null)
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                    "No orders found yet...",
                  style: TextStyle(color: Colors.grey,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if(dataSnapshot.data!.length > 0)
        {
          List<OrderDisplay> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index)
            {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index)
            {
              OrderDisplay eachOrderData = orderList[index];
              String Status = eachOrderData.status == true ? "Delivered" : "Pending";
              return Card(
                color: Colors.white24,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: ListTile(
                    onTap: ()
                    {
                      Get.to(OrderDetailsScreen(
                        clickedOrderInfo: eachOrderData,
                        booksData: allBookItemsList,
                      ));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID # " + eachOrderData.id.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Amount: \$" + eachOrderData.total.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // datetime
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              eachOrderData.createdDate.toString().split("T")[0],
                              style: const TextStyle(
                                color: Colors.grey
                              ),
                            ),

                            Text(
                              "Status: " + Status,
                              style: const TextStyle(
                                  color: Colors.grey
                              ),
                            ),

                            // time
                            // Text(
                            //   eachOrderData.createdDate.toString().split("T")[1],
                            //   style: const TextStyle(
                            //       color: Colors.grey
                            //   ),
                            // )
                          ],
                        ),

                        const SizedBox(width: 6,),

                        const Icon(
                          Icons.navigate_next,
                          color: Colors.purpleAccent,
                        ),

                      ],
                    ),
                  )
                ),
              );
            },
          );
        }
        else
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Nothing to show...",
                  style: TextStyle(color: Colors.grey,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
