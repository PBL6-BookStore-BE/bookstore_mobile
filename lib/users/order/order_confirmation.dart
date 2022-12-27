import 'dart:convert';
import 'dart:typed_data';

import 'package:books_app/users/fragments/dashboard_of_fragments.dart';
import 'package:books_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;


import '../model/cart.dart';
import '../model/order.dart';

class OrderConfirmationScreen extends StatelessWidget {

  final List<int>? selectedCartIDs;
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final String? paymentSystem;
  final double? totalAmount;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? receiverName;


  OrderConfirmationScreen({
    this.selectedCartIDs,
    this.selectedCartListItemsInfo,
    this.paymentSystem,
    this.totalAmount,
    this.phoneNumber,
    this.shipmentAddress,
    this.receiverName,
  });

  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;

  final ImagePicker _picker = ImagePicker();

  CurrentUser currentUser = Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage)
  {
    _imageSelectedByte.value = selectedImage;
  }

  setSelectedImageName(String selectedImageName)
  {
    _imageSelectedName.value = selectedImageName;
  }

  chooseImageFromGallery() async
  {
    final pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
    }
  }

  saveNewOrderInfo() async
  {
    List<String> selectedItemsString = selectedCartListItemsInfo!.map((eachSelectedItem)=> jsonEncode(eachSelectedItem)).toList();

    List orderDetails = [];

    for(var item in selectedItemsString) {
      var a = json.decode(item);
      OrderDetails i = OrderDetails(
          idBook: a['idBook'],
          quantity: a['quantity']
      );
      orderDetails.add(i);
    }
    print(orderDetails);
    int idPayment = paymentSystem != 'cod' ? 2:3;
    try
    {
      String token = currentUser.user.token;
      var res = await http.post(
        Uri.parse("https://localhost:7075/gateway/order"),
        body: jsonEncode({
          'orderDetails': orderDetails,
          'status': false,
          'idPayment': idPayment,
          'orderAddress': shipmentAddress,
          'receiverName': receiverName,
          'number': phoneNumber,
          'total': totalAmount.toString(),
        }),
          headers: {
            "Accept": "application/json",
            "content-type":"application/json",
            'Authorization': 'Bearer $token',
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfAddNewOrder = jsonDecode(res.body);
        //delete selected items from user cart
        selectedCartIDs!.forEach((eachSelectedItemCartID)
        {
          deleteSelectedItemsFromUserCartList(eachSelectedItemCartID);
        });
      }
      else
      {
        Fluttertoast.showToast(msg: "Error:: \nyour new order do NOT placed.");
      }
    }
    catch(erroeMsg)
    {
      Fluttertoast.showToast(msg: "Error: " + erroeMsg.toString());
    }
  }

  deleteSelectedItemsFromUserCartList(int cartID) async{
    {
      try
      {
        String token = currentUser.user.token;
        var res = await http.delete(
            Uri.parse("https://localhost:7075/gateway/cart/byid"),
            body:
            jsonEncode( {
              "id": cartID.toString(),
            }),
            headers: {
              "Accept": "application/json",
              "content-type":"application/json",
              'Authorization': 'Bearer $token',
            }
        );

        if(res.statusCode == 200)
        {
          Fluttertoast.showToast(msg: "Your new order has been placed Successfully!");
          Get.to(DashboardOfFragments());

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //image
          // Image.asset(
          //   "images/transaction.png",
          //   width: 160,
          // ),
          //
          // const SizedBox(height: 4,),

          //title
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Please Confirm Your Order!!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // const SizedBox(height: 30),
          //
          // //select image btn
          // Material(
          //   elevation: 8,
          //   color: Colors.purpleAccent,
          //   borderRadius: BorderRadius.circular(30),
          //   child: InkWell(
          //     onTap: ()
          //     {
          //       chooseImageFromGallery();
          //     },
          //     borderRadius: BorderRadius.circular(30),
          //     child: const Padding(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: 30,
          //         vertical: 12,
          //       ),
          //       child: Text(
          //         "Select Image",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          //
          // const SizedBox(height: 16),
          //
          // //display selected image by user
          // Obx(()=> ConstrainedBox(
          //   constraints: BoxConstraints(
          //     maxWidth: MediaQuery.of(context).size.width * 0.7,
          //     maxHeight: MediaQuery.of(context).size.width * 0.6,
          //   ),
          //   child: imageSelectedByte.length > 0
          //       ? Image.memory(imageSelectedByte, fit: BoxFit.contain,)
          //       : const Placeholder(color: Colors.white60,),
          // )),

          const SizedBox(height: 16),

          //confirm and proceed
          Obx(()=> Material(
            elevation: 8,
            color: imageSelectedByte.length < 0 ? Colors.grey : Colors.purpleAccent,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: ()
              {
                saveNewOrderInfo();
                // if(imageSelectedByte.length > 0)
                // {
                //   //save order info
                //   saveNewOrderInfo();
                // }
                // else
                // {
                //   Fluttertoast.showToast(msg: "Please attach the transaction proof / screenshot.");
                // }
              },
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "Confirmed & Proceed",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )),

        ],
        ),
      ),
    );
  }
}
