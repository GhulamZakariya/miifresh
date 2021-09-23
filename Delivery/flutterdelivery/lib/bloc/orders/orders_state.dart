part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();

  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();

  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
  final OrdersResponse ordersResponse;

  const OrdersLoaded(this.ordersResponse);

  @override
  List<Object> get props => [this.ordersResponse];
}

class OrderError extends OrdersState {
  final String error;

  const OrderError(this.error);

  @override
  List<Object> get props => [this.error];
}
