import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/NotificationModel.dart';
import '../../../data/repoistry/NotificationRepo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  NotificationCubit(this._repository) : super(NotificationInitial());

  Future<void> fetchNotifications(String userId) async {
    emit(NotificationLoading());

    try {
      final notifications = await _repository.fetchUserNotifications(userId);
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError('Failed to fetch notifications: $e'));
    }
  }
}
