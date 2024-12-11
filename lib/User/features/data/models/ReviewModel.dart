class ReviewModel {
  final String username;
  final String review;
  final String bookId;
  final int rating;

  ReviewModel({
    required this.username,
    required this.review,
    required this.bookId,
    required this.rating,

  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      username: map['username'],
      review: map['review'],
      bookId: map['bookId'],
      rating: map['rating'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'review': review,
      'bookId': bookId,
      'rating': rating,
    };
  }
}