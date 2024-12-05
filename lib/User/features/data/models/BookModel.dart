import 'dart:math';

class BookModel {
  String? id;
  String? title;
  List<String>? authors;
  String? publisher;
  String? publishedDate;
  String? category;
  int? pageCount;
  String? language;
  String? thumbnail;
  String? description;
  int? price;
  String? isbn;
  int? availability;
  int? popularity;

  BookModel({
    this.id,
    this.title,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.category,
    this.pageCount,
    this.language,
    this.thumbnail,
    this.description,
    this.price,
    this.isbn,
    this.availability,
    this.popularity,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['volumeInfo']['title'];
    authors = json['volumeInfo']['authors']?.cast<String>();
    publisher = json['volumeInfo']['publisher'];
    publishedDate = json['volumeInfo']['publishedDate'];
    category = (json['volumeInfo']['categories'] as List?)?.first;
    pageCount = json['volumeInfo']['pageCount'];
    language = json['volumeInfo']['language'];
    thumbnail = json['volumeInfo']['imageLinks']?['thumbnail'];
    description = json['volumeInfo']['description'];
    availability = 10;
    price = (json['saleInfo']['listPrice']?['amount'] as num?)?.toInt();
    isbn = json['volumeInfo']['industryIdentifiers']?.firstWhere(
          (identifier) =>
      identifier['type'] == 'ISBN_13' || identifier['type'] == 'ISBN_10',
      orElse: () => {},
    )['identifier'];
    popularity = Random().nextInt(5) + 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'category': category,
      'pageCount': pageCount,
      'language': language,
      'thumbnail': thumbnail,
      'description': description,
      'price': price,
      'isbn': isbn,
      'availability': availability,
      'popularity': popularity,
    };
  }
}
