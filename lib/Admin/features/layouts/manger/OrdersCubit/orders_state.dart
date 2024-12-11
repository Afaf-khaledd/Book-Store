part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}
class OrdersReportLoaded extends OrdersState {
  final List<OrderModel> reportOrders;

  const OrdersReportLoaded(this.reportOrders);
}

class OrderStatusUpdated extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}