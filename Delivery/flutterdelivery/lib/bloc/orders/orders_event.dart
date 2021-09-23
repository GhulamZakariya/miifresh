part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
}

class GetOrders extends OrdersEvent {
  final String pinCode;

  const GetOrders(this.pinCode);

  @override
  List<Object> get props => [this.pinCode];

}