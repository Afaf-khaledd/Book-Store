part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}
class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
class AuthResetPasswordLoading extends AuthState {}
class AuthResetPasswordSuccess extends AuthState {}
class AuthResetPasswordError extends AuthState {
  final String error;
  AuthResetPasswordError(this.error);
}

class AuthLogoutSuccess extends AuthState {}
class AuthLogoutError extends AuthState {
  final String error;
  AuthLogoutError(this.error);
}