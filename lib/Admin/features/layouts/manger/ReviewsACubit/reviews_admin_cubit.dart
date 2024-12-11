import 'package:bloc/bloc.dart';
import 'package:book_store/Admin/features/data/repoistry/ReviewsAdminRepo.dart';

part 'reviews_admin_state.dart';

class ReviewsAdminCubit extends Cubit<ReviewsAdminState> {
  final ReviewsAdminRepository _repository;

  ReviewsAdminCubit(this._repository) : super(ReviewsAdminInitial());

  void loadReviews() async {
    emit(ReviewsAdminLoading());
    try {
      final reviews = await _repository.fetchReviewsWithBookNames();
      emit(ReviewsAdminLoaded(reviews));
    } catch (e) {
      emit(ReviewsAdminError(e.toString()));
    }
  }
}