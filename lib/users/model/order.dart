class Order {
  String? selectedItems;
  bool? status;
  int? idPayment;
  String? orderAddress;
  String? receiverName;
  String? number;
  double? total;
  // OrderDetails? orderDetails;

  Order({
    this.selectedItems,
    this.status,
    this.idPayment,
    this.orderAddress,
    this.receiverName,
    this.number,
    this.total,
    // this.orderDetails
  });

  Order.fromJson(Map<String, dynamic> json){
    selectedItems = json['selectedItems'];
    status = json['status'];
    idPayment = json['idPayment'];
    orderAddress = json['orderAddress'];
    receiverName = json['receiverName'];
    number = json['number'];
    total = json['total'];
    // orderDetails = json['orderDetails'] != null
    //     ? new OrderDetails.fromJson(json['orderDetails'])
    //     : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedItems'] = this.selectedItems;
    data['status'] = this.status;
    data['idPayment'] = this.idPayment;
    data['orderAddress'] = this.orderAddress;
    data['receiverName'] = this.receiverName;
    data['number'] = this.number;
    data['total'] = this.total!.toStringAsFixed(2);
    // if(this.orderDetails != null){
    //   data['orderDetails'] = this.orderDetails!.toJson();
    // }
    return data;
  }
}

class OrderDisplay {
  int? id;
  bool? status;
  String? idUser;
  String? createdDate;
  String? orderAddress;
  String? payment;
  String? receiverName;
  String? number;
  String? total;
  List<dynamic>? orderDetails;


  OrderDisplay({
    this.id,
    this.idUser,
    this.createdDate,
    this.status,
    this.payment,
    this.orderAddress,
    this.receiverName,
    this.number,
    this.total,
    this.orderDetails
  });

  factory OrderDisplay.fromJson(Map<String, dynamic> json) => OrderDisplay(
    id: json["id"],
    idUser: json["idUser"],
    createdDate: json["createdDate"],
    status: json["status"],
    payment: json["payment"],
    orderAddress: json["orderAddress"],
    receiverName: json["receiverName"],
    number: json["number"],
    total: json["total"],
    orderDetails: json["orderDetails"]
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUser'] = this.idUser;
    data['createdDate'] = this.createdDate;
    data['status'] = this.status;
    data['payment'] = this.payment;
    data['orderAddress'] = this.orderAddress;
    data['receiverName'] = this.receiverName;
    data['number'] = this.number;
    data['total'] = this.total;
    data['orderDetails'] = this.orderDetails;
    return data;
  }
}

class OrderDetails {
  int? idBook;
  int? quantity;

  OrderDetails({
    this.idBook,
    this.quantity,
  });

  OrderDetails.fromJson(Map<String, dynamic> json){
    idBook = json['idBook'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idBook'] = this.idBook;
    data['quantity'] = this.quantity;
    return data;
  }

}
// class BookVM {
//   int? id;
//   String? name;
//   int? pages;
//   double? rating;
//   late double price;
//   String? categoryName;
//   String? publisherName;
//   String? publicationDate;
//   List<String>? authors;
//   List<String>? urls;
//   String? description;
//   String? urlFolder;
//
//   BookVM(
//       {this.id,
//         this.name,
//         this.pages,
//         this.rating,
//         required this.price,
//         this.categoryName,
//         this.publisherName,
//         this.publicationDate,
//         this.authors,
//         this.urls,
//         this.description,
//         this.urlFolder});
//
//   BookVM.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     pages = json['pages'];
//     rating = json['rating'];
//     price = json['price'];
//     categoryName = json['categoryName'];
//     publisherName = json['publisherName'];
//     publicationDate = json['publicationDate'];
//     authors = json['authors'].cast<String>();
//     urls = json['urls'].cast<String>();
//     description = json['description'];
//     urlFolder = json['urlFolder'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['pages'] = this.pages;
//     data['rating'] = this.rating;
//     data['price'] = this.price;
//     data['categoryName'] = this.categoryName;
//     data['publisherName'] = this.publisherName;
//     data['publicationDate'] = this.publicationDate;
//     data['authors'] = this.authors;
//     data['urls'] = this.urls;
//     data['description'] = this.description;
//     data['urlFolder'] = this.urlFolder;
//     return data;
//   }
// }

// class OrderVM {
//   int? id;
//   String? name;
//   String? pages;
//   double? rating;
//   late double price;
//   String? categoryName;
//   String? publisherName;
//   String? publicationDate;
//   List<String>? authors;
//   List<String>? urls;
//   String? description;
//   String? urlFolder;
//
//   OrderVM(
//       {this.id,
//         this.name,
//         this.pages,
//         this.rating,
//         required this.price,
//         this.categoryName,
//         this.publisherName,
//         this.publicationDate,
//         this.authors,
//         this.urls,
//         this.description,
//         this.urlFolder});
//
//   BookVM.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     pages = json['pages'];
//     rating = json['rating'];
//     price = json['price'];
//     categoryName = json['categoryName'];
//     publisherName = json['publisherName'];
//     publicationDate = json['publicationDate'];
//     authors = json['authors'].cast<String>();
//     urls = json['urls'].cast<String>();
//     description = json['description'];
//     urlFolder = json['urlFolder'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['pages'] = this.pages;
//     data['rating'] = this.rating;
//     data['price'] = this.price;
//     data['categoryName'] = this.categoryName;
//     data['publisherName'] = this.publisherName;
//     data['publicationDate'] = this.publicationDate;
//     data['authors'] = this.authors;
//     data['urls'] = this.urls;
//     data['description'] = this.description;
//     data['urlFolder'] = this.urlFolder;
//     return data;
//   }
// }