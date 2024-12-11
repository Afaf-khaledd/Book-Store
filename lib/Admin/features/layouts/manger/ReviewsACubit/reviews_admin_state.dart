part of 'reviews_admin_cubit.dart';

abstract class ReviewsAdminState {}

final class ReviewsAdminInitial extends ReviewsAdminState {}

class ReviewsAdminLoading extends ReviewsAdminState {}

class ReviewsAdminLoaded extends ReviewsAdminState {
  final List<Map<String, dynamic>> reviews;

  ReviewsAdminLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}
class ReviewsAdminError extends ReviewsAdminState {
  final String message;

  ReviewsAdminError(this.message);

  @override
  List<Object?> get props => [message];
}