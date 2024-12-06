import 'dart:math';

class BookModel {
  String? id;
  String? title;
  List<String>? authors;
  String? publisher;
  String? publishedDate;
  String? category;
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
    title = json['volumeInfo']?['title'] ?? json['title'];
    authors = (json['volumeInfo']?['authors'] ?? json['authors'])?.cast<String>();
    publisher = json['volumeInfo']?['publisher'] ?? json['publisher'];
    publishedDate = json['volumeInfo']?['publishedDate'] ?? json['publishedDate'];
    category = (json['volumeInfo']?['categories'] ?? [json['category']]).first;
    language = json['volumeInfo']?['language'] ?? json['language'];
    thumbnail = json['volumeInfo']?['imageLinks']?['thumbnail'] ?? json['thumbnail'];
    description = json['volumeInfo']?['description'] ?? json['description'];
    price = (json['saleInfo']?['listPrice']?['amount'] as num?)?.toInt() ??
        Random().nextInt(500) + 1;
    isbn = json['volumeInfo']?['industryIdentifiers']?.firstWhere(
          (identifier) => identifier['type'] == 'ISBN_13' || identifier['type'] == 'ISBN_10',
      orElse: () => {},
    )['identifier'] ?? json['isbn'];
    availability = Random().nextInt(50) + 1;
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
