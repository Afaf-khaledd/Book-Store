import 'package:bloc/bloc.dart';
import 'package:book_store/Admin/features/data/repoistry/OrderRepository.dart';
import 'package:equatable/equatable.dart';

import '../../../../../User/features/data/models/OrderModel.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository _repository;
  OrdersCubit(this._repository) : super(OrdersInitial());

  Future<void> fetchOrders() async {
    emit(OrdersLoading());

    try {
      final orders = await _repository.fetchAllOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Failed to load orders: $e'));
    }
  }
  Future<void> fetchOrdersForReport(DateTime date) async {
    try {
      emit(OrdersLoading());
      final orders = await _repository.fetchOrdersByDate(date);
      emit(OrdersReportLoaded(orders));
    } catch (e) {
      emit(OrdersError('Failed to fetch report: ${e.toString()}'));
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _repository.updateOrderStatus(orderId, status);
      emit(OrderStatusUpdated());
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}