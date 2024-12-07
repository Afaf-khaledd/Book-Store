import 'package:bloc/bloc.dart';

import '../../../data/models/ReviewModel.dart';
import '../../../data/repoistry/ReviewRepo.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewCubit(this._reviewRepository) : super(ReviewInitial());

  Future<void> loadReviews(String bookId) async {
    emit(ReviewLoading());
    try {
      final reviews = await _reviewRepository.fetchReviews(bookId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError('Failed to load reviews: $e'));
    }
  }

  Future<void> submitReview(ReviewModel review) async {
    emit(ReviewSubmitting());
    try {
      await _reviewRepository.submitReview(review);
      emit(ReviewSubmitted());
    } catch (e) {
      emit(ReviewSubmitError('Failed to submit review: $e'));
    }
  }
}