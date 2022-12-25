import 'dart:convert';

import 'package:books_app/users/model/books.dart';
import 'package:books_app/users/model/order.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget
{
  final OrderDisplay? clickedOrderInfo;
  final List<Books>? booksData;

  OrderDetailsScreen({this.clickedOrderInfo, this.booksData});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text(
          widget.clickedOrderInfo!.createdDate!.toString().split("T")[0],
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // display items belongs to clicked order
              displayClickedOrderItems(),

              const SizedBox(height: 16,),

              //phoneNumber
              showTitleText("Phone Number: "),
              const SizedBox(height: 8,),
              showContentText(widget.clickedOrderInfo!.number!),

              const SizedBox(height: 26,),

              //shipping address
              showTitleText("Shipping Address: "),
              const SizedBox(height: 8,),
              showContentText(widget.clickedOrderInfo!.orderAddress!),

              const SizedBox(height: 26,),

              //Payment
              showTitleText("Payment: "),
              const SizedBox(height: 8,),
              showContentText(widget.clickedOrderInfo!.payment!.toUpperCase()),

              const SizedBox(height: 26,),

              //Status
              showTitleText("Status: "),
              const SizedBox(height: 8,),
              showContentText(widget.clickedOrderInfo!.status! == true ? "Delivered" : "Pending"),

              const SizedBox(height: 26,),

              //Total
              showTitleText("Total: "),
              const SizedBox(height: 8,),
              showContentText(widget.clickedOrderInfo!.total!),

              const SizedBox(height: 8,),

            ],
          ),
        ),
      ),
    );
  }

  Widget showTitleText(String titleText)
  {
    return Text(
      titleText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget showContentText(String contentText)
  {
    return Text(
      contentText,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  Widget displayClickedOrderItems()
  {
    List<dynamic> clickedOrderItemsInfo = widget.clickedOrderInfo!.orderDetails!;
    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index)
      {
        Map<String, dynamic> itemInfo = clickedOrderItemsInfo[index];

        var books = jsonEncode(widget!.booksData!);
        List<dynamic> myMap = json.decode(books);
        var myBook;
        myMap.forEach((element) {
          if (element["id"] == itemInfo["idBook"]) {
            myBook = element;
          }
        });

        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == clickedOrderItemsInfo.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow:
            const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.black26,
              ),
            ],
          ),
          child: Row(
            children: [
              // image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: FadeInImage(
                  height: 150,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/place_holder.png"),
                  image: NetworkImage(
                      myBook["urls"].first
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

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Name
                      Text(
                        myBook["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Quantity: " + itemInfo["quantity"].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      //price
                      Text(
                        myBook["price"].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "\$ " + (itemInfo["quantity"]*myBook["price"]).toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

}