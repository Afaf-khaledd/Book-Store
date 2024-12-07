class ReviewModel {
  final String username;
  final String review;
  final String bookId;

  ReviewModel({
    required this.username,
    required this.review,
    required this.bookId,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      username: map['username'],
      review: map['review'],
      bookId: map['bookId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'review': review,
      'bookId': bookId,
    };
  }
}