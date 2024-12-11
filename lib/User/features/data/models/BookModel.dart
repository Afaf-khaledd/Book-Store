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
  int? salesCount; // Add the salesCount field

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? publisher,
    String? publishedDate,
    String? category,
    String? language,
    String? thumbnail,
    String? description,
    int? price,
    String? isbn,
    int? availability,
    int? popularity,
    int? salesCount, // Include salesCount in copyWith
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publisher: publisher ?? this.publisher,
      publishedDate: publishedDate ?? this.publishedDate,
      category: category ?? this.category,
      language: language ?? this.language,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      price: price ?? this.price,
      isbn: isbn ?? this.isbn,
      availability: availability ?? this.availability,
      popularity: popularity ?? this.popularity,
      salesCount: salesCount ?? this.salesCount, // Add salesCount to copyWith
    );
  }

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
    this.salesCount, // Add salesCount to constructor
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
    price = (json['saleInfo']?['listPrice']?['amount'] as num?)?.toInt();
    isbn = json['volumeInfo']?['industryIdentifiers']?.firstWhere(
          (identifier) => identifier['type'] == 'ISBN_13' || identifier['type'] == 'ISBN_10',
      orElse: () => {},
    )['identifier'] ?? json['isbn'];
    availability = json['availability'] ?? 0;
    popularity = json['popularity'] ?? 0;
    salesCount = json['salesCount'] ?? 0; // Ensure salesCount is loaded from JSON
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
      'salesCount': salesCount, // Include salesCount in toJson
    };
  }
}
