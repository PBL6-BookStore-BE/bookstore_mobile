import 'dart:convert';

import 'package:books_app/users/model/books.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/cart_list_controller.dart';
import '../model/cart.dart';
import '../userPreferences/current_user.dart';

class CartListScreen extends StatefulWidget
{

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}


class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async
  {
    List<Cart> cartListOfCurrentUser = [];

    try
    {
      String token = currentOnlineUser.user.token;
      var res = await http.get(
          Uri.parse("https://localhost:7075/gateway/details"),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json",
            'Authorization': 'Bearer $token',
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
          (responseBodyOfGetCurrentUserCartItems as List).forEach((eachCurrentUserCartItemData)
          {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));
          });


        cartListController.setList(cartListOfCurrentUser);
      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount()
  {
    cartListController.setTotal(0);

    if(cartListController.selectedItemList.length > 0)
    {
      cartListController.cartList.forEach((itemInCart)
      {
        if(cartListController.selectedItemList.contains(itemInCart.id))
        {
           var price = itemInCart.bookVM?.price;
           double eachItemTotalAmount = 0;
           if (price!= null){
             eachItemTotalAmount = price * (int.parse(itemInCart.quantity.toString()));
           }
          cartListController.setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
    }
  }


  deleteSelectedItemsFromUserCartList(int cartDetailID) async
  {
    try
    {
      String token = currentOnlineUser.user.token;
      var res = await http.delete(
          Uri.parse("https://localhost:7075/gateway/cart/byid"),
          body:
          jsonEncode( {
            "id": cartDetailID.toString(),
          }),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json",
            'Authorization': 'Bearer $token',
          }
      );

      if(res.statusCode == 200)
      {

          getCurrentUserCartList();

      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  updateQuantityInUserCart(int cartID, int newQuantity) async
  {
    try
    {
      String token = currentOnlineUser.user.token;
      var res = await http.put(
          Uri.parse("https://localhost:7075/gateway/cart/byid"),
          body:
          jsonEncode({
            "idBook": cartID.toString(),
            "quantity": newQuantity.toString(),
          }),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json",
            'Authorization': 'Bearer $token',
          }
      );

      if(res.statusCode == 200)
      {
          getCurrentUserCartList();

      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
            "My Cart"
        ),
        actions: [

          //to select all items
          Obx(()=>
              IconButton(
                onPressed: ()
                {
                  cartListController.setIsSelectedAllItems();
                  cartListController.clearAllSelectedItems();

                  if(cartListController.isSelectedAll)
                  {
                    cartListController.cartList.forEach((eachItem)
                    {
                      cartListController.addSelectedItem(eachItem.id!);
                    });
                  }

                  calculateTotalAmount();
                },
                icon: Icon(
                  cartListController.isSelectedAll
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: cartListController.isSelectedAll
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
          ),

          //to delete selected item/items
          GetBuilder(
              init: CartListController(),
              builder: (c)
              {
                if(cartListController.selectedItemList.length > 0)
                {
                  return IconButton(
                    onPressed: () async
                    {
                      var responseFromDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text("Delete"),
                          content: const Text("Are you sure to Delete selected items from your Cart List?"),
                          actions:
                          [
                            TextButton(
                              onPressed: ()
                              {
                                Get.back();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: ()
                              {
                                Get.back(result: "yesDelete");
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if(responseFromDialogBox == "yesDelete")
                      {
                        cartListController.selectedItemList.forEach((selectedItemUserCartID)
                        {
                          //delete selected items now
                          deleteSelectedItemsFromUserCartList(selectedItemUserCartID);
                        });
                      }

                      calculateTotalAmount();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      size: 26,
                      color: Colors.redAccent,
                    ),
                  );
                }
                else
                {
                  return Container();
                }
              }
          ),

        ],
      ),
      body: Obx(()=>
          cartListController.cartList.length > 0
              ? ListView.builder(
              itemCount: cartListController.cartList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
              Cart cartModel = cartListController.cartList[index];
              List<String>? urls_list = cartModel.bookVM!.urls ;
              urls_list ??= ["images/place_holder.png"];

              Books booksModel = Books(
                id: cartModel.bookVM!.id,
                name: cartModel.bookVM!.name,
                pages: cartModel.bookVM!.pages,
                rating: cartModel.bookVM!.rating,
                price: cartModel.bookVM!.price,
                categoryName: cartModel.bookVM!.categoryName,
                publisherName: cartModel.bookVM!.publisherName,
                description: cartModel.bookVM!.description,
                urls:urls_list,
                urlFolder: cartModel.bookVM!.urlFolder,
                authors: cartModel.bookVM!.authors,
              );

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [

                    //check box
                    GetBuilder(
                      init: CartListController(),
                      builder: (c)
                      {
                        return IconButton(
                          onPressed: ()
                          {
                            if(cartListController.selectedItemList.contains(cartModel.id))
                            {
                              cartListController.deleteSelectedItem(cartModel.id!);
                            }
                            else
                            {
                              cartListController.addSelectedItem(cartModel.id!);
                            }

                            calculateTotalAmount();
                          },
                          icon: Icon(
                            cartListController.selectedItemList.contains(cartModel.id)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: cartListController.isSelectedAll
                                ? Colors.white
                                : Colors.grey,
                          ),
                        );
                      },
                    ),

                    //name
                    //color size + price
                    //+ 2 -
                    //image
                    Expanded(
                      child: GestureDetector(
                        onTap: ()
                        {

                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                            0,
                            index == 0 ? 16 : 8,
                            16,
                            index == cartListController.cartList.length - 1 ? 16 : 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                            boxShadow:
                            const [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              //name
                              //author
                              //+ 2 -
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      //name
                                      Text(
                                        booksModel.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      //author + price
                                      Row(
                                        children: [

                                          //author
                                          Expanded(
                                            child:  Text(
                                              booksModel.authors.toString().replaceAll("[", "").replaceAll("]", ""),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white60,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          //price
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12.0
                                            ),
                                            child: Text(
                                              "\$" + booksModel.price.toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.purpleAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                      const SizedBox(height: 20),

                                      // + 2 -
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          //-
                                          IconButton(
                                            onPressed: ()
                                            {
                                              if(cartModel.quantity! - 1 >= 1)
                                              {
                                                updateQuantityInUserCart(
                                                  cartModel.id!,
                                                  cartModel.quantity! - 1,
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),

                                          const SizedBox(width: 10,),

                                          Text(
                                            cartModel.quantity.toString(),
                                            style: const TextStyle(
                                              color: Colors.purpleAccent,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(width: 10,),

                                          //+
                                          IconButton(
                                            onPressed: ()
                                            {
                                              updateQuantityInUserCart(
                                                cartModel.id!,
                                                cartModel.quantity! + 1,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // item image
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
                                    booksModel.urls.first,
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
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              : Center(
                child: const Text("Cart is Empty"),
                ),
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c)
        {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [

                //total amount
                const Text(
                  "Total Amount:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Obx(()=>
                    Text(
                      "\$ " + cartListController.total.toStringAsFixed(2),
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),

                const Spacer(),

                //order now btn
                Material(
                  color: cartListController.selectedItemList.length > 0
                      ? Colors.purpleAccent
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: ()
                    {

                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );

  }
}
