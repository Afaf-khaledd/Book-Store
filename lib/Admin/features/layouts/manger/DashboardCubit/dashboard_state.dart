part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalUsers;
  final int totalOrders;
  final int totalBooks;
  final int totalCategories;
  final List<Map<String, dynamic>> popularCategories;
  final List<Map<String, dynamic>> bestSellingBooks;

  DashboardLoaded({
    required this.totalUsers,
    required this.totalOrders,
    required this.totalBooks,
    required this.totalCategories,
    required this.popularCategories,
    required this.bestSellingBooks,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}