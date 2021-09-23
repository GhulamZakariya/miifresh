part of 'order_status_bloc.dart';


abstract class OrderStatusState extends Equatable {
  const OrderStatusState();
}

class OrderStatusInitial extends OrderStatusState {
  const OrderStatusInitial();

  @override
  List<Object> get props => [];
}

class OrderStatusLoading extends OrderStatusState {
  const OrderStatusLoading();

  @override
  List<Object> get props => [];
}

class OrderStatusLoaded extends OrderStatusState {
  final ChangeOrderStatusResponse response;

  const OrderStatusLoaded(this.response);

  @override
  List<Object> get props => [this.response];
}

class OrderStatusError extends OrderStatusState {
  final String error;

  const OrderStatusError(this.error);

  @override
  List<Object> get props => [this.error];
}
