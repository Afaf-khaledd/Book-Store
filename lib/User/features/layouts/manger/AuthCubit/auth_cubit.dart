import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/SharedPreference.dart';
import '../../../data/models/UserModel.dart';
import '../../../data/repoistry/AuthRepo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  UserModel? _cachedUser;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<UserModel?> get currentUser async {
    _cachedUser ??= await authRepository.currentUser;
    return _cachedUser;
  }
  UserModel? get cachedUser => _cachedUser;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await authRepository.login(email, password);
      _cachedUser = await authRepository.currentUser;
      emit(AuthSuccess("Login successful!"));
    } catch (e) {
      emit(AuthError("Failed to login: $e"));
    }
  }
  Future<void> signUp(UserModel user, String password) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp(user, password);
      _cachedUser = await authRepository.currentUser;
      emit(AuthSuccess("Sign up successful!"));
    } catch (e) {
      emit(AuthError("Failed to sign up: $e"));
    }
  }
  Future<void> resetPassword(String email) async {
    emit(AuthResetPasswordLoading());
    try {
      await authRepository.resetPassword(email);
      emit(AuthResetPasswordSuccess());
    } catch (e) {
      emit(AuthResetPasswordError(e.toString()));
    }
  }
  Future<void> changePassword(String newPassword) async {
    try {
      final user = await authRepository.currentUser;

      if (user != null) {

        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);

        emit(AuthPasswordChangeSuccess());
      } else {
        emit(AuthError('No user is logged in.'));
      }
    } catch (e) {
      emit(AuthPasswordChangeError('Failed to change password: $e'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthLogoutSuccess());
      SharedPreference().setRememberMe(false);
    } catch (e) {
      emit(AuthLogoutError("Failed to logout: $e"));
    }
  }
}