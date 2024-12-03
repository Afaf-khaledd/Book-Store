import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/UserModel.dart';
import '../../../data/repoistry/AuthRepo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await authRepository.login(email, password);
      emit(AuthSuccess("Login successful!"));
    } catch (e) {
      emit(AuthError("Failed to login: $e"));
    }
  }

  Future<void> signUp(UserModel user, String password) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp(user, password);
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

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthLogoutSuccess());
    } catch (e) {
      emit(AuthLogoutError("Failed to logout: $e"));
    }
  }
  /*Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await authRepository.loginWithGoogle();
      if (user != null) {
        emit(AuthSuccess("Google login successful!"));
      } else {
        emit(AuthError("Google login canceled."));
      }
    } catch (e) {
      emit(AuthError("Google login failed: $e"));
    }
  }*/

  /*Future<void> loginWithFacebook() async {
    emit(AuthLoading());
    try {
      final user = await authRepository.loginWithFacebook();
      if (user != null) {
        emit(AuthSuccess("Facebook login successful!"));
      } else {
        emit(AuthError("Facebook login canceled."));
      }
    } catch (e) {
      emit(AuthError("Facebook login failed: $e"));
    }
  }*/
}