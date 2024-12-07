class CartItemModel {
  final String bookId;
  final String image;
  final String title;
  final int price;
  final int quantity;

  CartItemModel({
    required this.bookId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'title': title,
    'image': image,
    'price': price,
    'quantity': quantity,
  };

  static CartItemModel fromJson(Map<String, dynamic> json) => CartItemModel(
    bookId: json['bookId'],
    title: json['title'],
    image: json['image'],
    price: json['price'],
    quantity: json['quantity'],
  );
}