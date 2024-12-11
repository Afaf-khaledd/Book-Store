import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repoistry/DashboardRepo.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardCubit(this.dashboardRepository) : super(DashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(DashboardLoading());

    try {
      final totalUsers = await dashboardRepository.fetchTotalUsers();
      final totalOrders = await dashboardRepository.fetchTotalOrders();
      final totalBooks = await dashboardRepository.fetchTotalBooks();
      final totalCategories = await dashboardRepository.fetchTotalCategories();
      final popularCategories = await dashboardRepository.fetchPopularCategories();
      final bestSellingBooks = await dashboardRepository.fetchBestSellingBooks();

      emit(DashboardLoaded(
        totalUsers: totalUsers,
        totalOrders: totalOrders,
        totalBooks: totalBooks,
        totalCategories: totalCategories,
        popularCategories: popularCategories,
        bestSellingBooks: bestSellingBooks,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}