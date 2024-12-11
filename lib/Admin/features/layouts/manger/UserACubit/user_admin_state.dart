part of 'user_admin_cubit.dart';

abstract class UserAdminState {}

final class UserAdminInitial extends UserAdminState {}
final class UserAdminLoading extends UserAdminState {}
final class UserAdminLoaded extends UserAdminState {
  final int usersLength;
  UserAdminLoaded(this.usersLength);

}
final class UserAdminError extends UserAdminState {
  final String message;

  UserAdminError(this.message);

  @override
  List<Object?> get props => [message];
}

