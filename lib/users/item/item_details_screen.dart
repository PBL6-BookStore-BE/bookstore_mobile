import 'dart:convert';

import 'package:books_app/users/controllers/item_details_controller.dart';
import 'package:books_app/users/model/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../userPreferences/current_user.dart';
import '../userPreferences/user_preferences.dart';
import '../fragments/dashboard_of_fragments.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Books? itemInfo;
  ItemDetailsScreen({this.itemInfo,});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{
  final itemDetailsController = Get.put(ItemDetailsController());
  final CurrentUser _currentUser = Get.put(CurrentUser());
  addItemToCart() async
  {
    try
    {
      String token = _currentUser.user.token;
      var res = await http.post(
          Uri.parse("https://localhost:7075/gateway/details"),
          body: jsonEncode({
            "quantity" : itemDetailsController.quantity,
            "id" : widget.itemInfo!.id
          }),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json",
            'Authorization': 'Bearer $token',
          }

      );

      if (res.statusCode == 200) {
        var resBodyOfAddCartDetail = jsonDecode(res.body);
        Fluttertoast.showToast(msg: "book added to cart successfully.");
      }
      else
        {
          Fluttertoast.showToast(msg: "Error occurred.\nPlease try again.");
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          //item image
          FadeInImage(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/place_holder.png"),
            image: NetworkImage(
              widget.itemInfo!.urls.first,
            ),
            imageErrorBuilder: (context, error, stackTraceError)
            {
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                ),
              );
            },
          ),

        //  item information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),

        ],
      ),
    );
  }

  itemInfoWidget(){
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.purpleAccent,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 18,),

              Center(
                child: Container(
                  height: 8,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 30,),

            //  name
              Text(
                widget.itemInfo!.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10,),

              //rating + rating num
              // category
              //author
              //price
              //quantity item counter
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rating + rating num
                  // category
                  //author
                  //price
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //rating + rating num
                          Row(
                            children: [

                            // rating bar
                              RatingBar.builder(
                                initialRating: widget.itemInfo!.rating!,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, c)=> const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (updateRating){},
                                ignoreGestures: true,
                                unratedColor: Colors.grey,
                                itemSize: 20,
                              ),
                              const SizedBox(width: 8,),

                            // rating num
                              Text(
                                "(" + widget.itemInfo!.rating.toString() + ")",
                                style: const TextStyle(
                                  color: Colors.purpleAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // category
                          Text(
                            "Category: " + widget.itemInfo!.categoryName.toString().replaceAll("[", "").replaceAll("]", ""),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 10),

                          //author
                          Text(
                            "Author: " + widget.itemInfo!.authors!.toString().replaceAll("[", "").replaceAll("]", ""),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 16),

                          //price
                          Text(
                            "\$" + widget.itemInfo!.price.toString(),
                            style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                        ],
                    ),
                  ),

                  //quantity item counter
                  Obx(
                          () => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //+
                          IconButton(
                            onPressed: ()
                            {
                              itemDetailsController.setQuantityItem(itemDetailsController.quantity + 1);
                            },
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                          ),
                          Text(
                              itemDetailsController.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          //-
                          IconButton(
                            onPressed: ()
                            {
                              if (itemDetailsController.quantity - 1 >= 1)
                              {
                                itemDetailsController.setQuantityItem(itemDetailsController.quantity - 1);
                              }
                              else
                              {
                                Fluttertoast.showToast(msg: "Quantity must be 1 or greater than 1");
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                          ),
                        ],
                      )
                  ),
                ],
              ),

              //description
              const Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                widget.itemInfo!.description!,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30,),

              //add to cart button
              Material(
                elevation: 4,
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: ()
                  {
                      addItemToCart();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container (
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ),

              const SizedBox(height: 30,),

            ],
        ),
      ),
    );
  }
}
