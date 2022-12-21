

class Books {
  int? id;
  String? name;
  int? pages;
  double? rating;
  double? price;
  String? categoryName;
  String? publisherName;
  String? publicationDate;
  List<String>? authors;
  late List<String> urls;
  String? description;
  String? urlFolder;

  Books(
      {this.id,
        this.name,
        this.pages,
        this.rating,
        this.price,
        this.categoryName,
        this.publisherName,
        this.publicationDate,
        this.authors,
        required this.urls,
        this.description,
        this.urlFolder});

  // factory Books.fromJson(Map<String, dynamic> json) => Books (
  //   id : int.parse(json['id']),
  //   name : json['name'],
  //   pages : int.parse(json['pages']),
  //   rating : double.parse(json['rating']),
  //   price : double.parse(json['price']),
  //   categoryName : json['categoryName'],
  //   publisherName : json['publisherName'],
  //   publicationDate : json['publicationDate'],
  //   authors : json['authors'].cast<String>(),
  //   urls : json['urls'].cast<String>(),
  //   description : json['description'],
  //   urlFolder : json['urlFolder'],
  // );

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pages = json['pages'];
    rating = json['rating'];
    price = json['price'];
    categoryName = json['categoryName'];
    publisherName = json['publisherName'];
    publicationDate = json['publicationDate'];
    authors = json['authors'].toString().split(", ");
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