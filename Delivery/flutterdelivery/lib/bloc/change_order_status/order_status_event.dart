part of 'order_status_bloc.dart';

abstract class OrderStatusEvent extends Equatable {
  const OrderStatusEvent();
}

class ChangeOrderStatus extends OrderStatusEvent {
  final String orderId;
  final String orderStatusId;
  final String comment;
  final String pinCode;

  const ChangeOrderStatus(
      this.orderId, this.orderStatusId, this.comment, this.pinCode);

  @override
  List<Object> get props => [this.orderId, this.orderStatusId, this.comment, this.pinCode];
}
