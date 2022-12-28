import 'dart:convert';

import 'package:books_app/users/cart/cart_list_screen.dart';
import 'package:books_app/users/controllers/cart_list_controller.dart';
import 'package:books_app/users/item/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../item/search_items.dart';
import '../model/books.dart';
import 'package:flutter/src/material/colors.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();



  Future<List<Books>> getTrendingBookItems() async
  {
    List<Books> trendingBookItemsList = [];
    try
    {
      var res = await http.get(
          Uri.parse("https://localhost:7075/gateway/topbook")
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        (responseBodyOfTrending as List).forEach((eachRecord)
        {
          trendingBookItemsList.add(Books.fromJson(eachRecord));
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

    return trendingBookItemsList;
  }

  Future<List<Books>> getAllBookItems() async
  {
    List<Books> allBookItemsList = [];
    try
    {
      var res = await http.get(
          Uri.parse("https://localhost:7075/gateway/books")
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        // print(responseBodyOfTrending);
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

    return allBookItemsList;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:16,),

            //search bar widget
            showSearchBarWidget(),

            //popular trending items
            const SizedBox(height:26,),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text("Trending",
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize:24,
                ),),
            ),
            trendingMostPopularBookItemWidget(context),
            const SizedBox(height:24,),

            //new items
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text("New Collections",
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize:24,
                ),),
            ),

            allBookItemWidget(context),
          ],
        )

    );
  }
  Widget showSearchBarWidget()
  {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal:18),
        child: TextField(
            style: const TextStyle(color: Colors.black),
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                  onPressed: ()
                  {
                    Get.to(SearchItems(typedKeyWords: searchController.text));
                  },
                  icon: const Icon(
                      Icons.search,
                      color: Colors.purpleAccent
                  )

              ),
              hintText: "Search best books here ...",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              suffixIcon: IconButton(
                onPressed: (){
                  Get.to(CartListScreen());
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.purpleAccent,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.purple,
                  )

              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.purpleAccent,
                  )

              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal:16,
                vertical: 8,
              ),
            )
        )
    )
    ;
  }

  Widget trendingMostPopularBookItemWidget(context)
  {
    return FutureBuilder(
      future: getTrendingBookItems(),
      builder: (context, AsyncSnapshot<List<Books>> dataSnapShot)
      {
        if(dataSnapShot.connectionState == ConnectionState.waiting)
        {
          print("Dang cho");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapShot.data == null)
        {
          return const Center(
            child: Text(
              "No Trending item found",
            ),
          );
        }
        if(dataSnapShot.data!.length > 0)
        {
          print("Co du lieu roi ne");
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index)
              {
                Books eachBookItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailsScreen(itemInfo: eachBookItemData));
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow:
                      const [
                        BoxShadow(
                          offset: Offset(0,3),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        //item image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachBookItemData.urls.first,
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
                        ),

                        //item name & price
                        //rating stars & rating numbers
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              //item name & price
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachBookItemData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "\$"+ eachBookItemData.price.toString(),
                                    style: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8,),

                              //rating stars & rating numbers
                              Row(
                                children: [

                                  RatingBar.builder(
                                    initialRating: eachBookItemData.rating!,
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

                                  Text(
                                    "(" + eachBookItemData.rating.toString() + ")",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        else
        {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

  allBookItemWidget(context){
    return FutureBuilder(
        future: getAllBookItems(),
        builder: (context, AsyncSnapshot<List<Books>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null)
          {
            return const Center(
              child: Text(
                "No Trending item found",
              ),
            );
          }
          if(dataSnapShot.data!.length > 0)
          {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
                Books eachBookItemRecord = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(ItemDetailsScreen(itemInfo: eachBookItemRecord));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow:
                      const [
                        BoxShadow(
                          offset: Offset(0,0),
                          blurRadius: 6,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        //name + price
                        //tags
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //name and price
                                Row(
                                  children: [

                                    //name
                                    Expanded(
                                      child: Text(
                                        eachBookItemRecord.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    //price
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                      child: Text(
                                        "\$ " + eachBookItemRecord.price.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.purpleAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                                const SizedBox(height: 16,),

                                //category
                                Text(
                                  "Category: " + eachBookItemRecord.categoryName.toString().replaceAll("[", "").replaceAll("]", ""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                  ),
                                ),

                                //description
                                Text(
                                  eachBookItemRecord.description.toString().replaceAll("[", "").replaceAll("]", ""),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),

                                RatingBar.builder(
                                  initialRating: eachBookItemRecord.rating!,
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

                              ],
                            ),
                          ),
                        ),

                        //image clothes
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachBookItemRecord.urls.first,
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
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        }
    );
  }
}