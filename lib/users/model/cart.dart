class Cart {
  int? id;
  int? quantity;
  BookVM? bookVM;

  Cart({this.id, this.quantity, this.bookVM});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    bookVM =
    json['bookVM'] != null ? new BookVM.fromJson(json['bookVM']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    if (this.bookVM != null) {
      data['bookVM'] = this.bookVM!.toJson();
    }
    return data;
  }
}

class BookVM {
  int? id;
  String? name;
  int? pages;
  double? rating;
  late double price;
  String? categoryName;
  String? publisherName;
  String? publicationDate;
  List<String>? authors;
  List<String>? urls;
  String? description;
  String? urlFolder;

  BookVM(
      {this.id,
        this.name,
        this.pages,
        this.rating,
        required this.price,
        this.categoryName,
        this.publisherName,
        this.publicationDate,
        this.authors,
        this.urls,
        this.description,
        this.urlFolder});

  BookVM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pages = json['pages'];
    rating = json['rating'];
    price = json['price'];
    categoryName = json['categoryName'];
    publisherName = json['publisherName'];
    publicationDate = json['publicationDate'];
    authors = json['authors'].cast<String>();
    urls = json['urls'].cast<String>();
    description = json['description'];
    urlFolder = json['urlFolder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pages'] = this.pages;
    data['rating'] = this.rating;
    data['price'] = this.price;
    data['categoryName'] = this.categoryName;
    data['publisherName'] = this.publisherName;
    data['publicationDate'] = this.publicationDate;
    data['authors'] = this.authors;
    data['urls'] = this.urls;
    data['description'] = this.description;
    data['urlFolder'] = this.urlFolder;
    return data;
  }
}
