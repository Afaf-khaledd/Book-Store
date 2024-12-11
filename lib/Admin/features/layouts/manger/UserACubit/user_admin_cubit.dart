import 'package:bloc/bloc.dart';

import '../../../data/repoistry/UserRepo.dart';

part 'user_admin_state.dart';

class UserAdminCubit extends Cubit<UserAdminState> {
  final UserRepository userRepository;

  UserAdminCubit(this.userRepository) : super(UserAdminInitial());

  Future<int> fetchUsersCount() async {
    emit(UserAdminLoading());
    try {
      final userCount = await userRepository.fetchUsersCount();
      emit(UserAdminLoaded(userCount));
      return userCount;
    } catch (e) {
      emit(UserAdminError('Failed to fetch user count: $e'));
    }
    return 0;
  }
}