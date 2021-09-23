import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutterdelivery/api/responses/orders_response.dart';
import 'package:flutterdelivery/repositories/orders_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState>{

  final OrdersRepo ordersRepo;

  OrdersBloc(this.ordersRepo) : super(OrdersInitial());

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {

    if (event is GetOrders){

      try {
        final orderResponse = await ordersRepo.getOrders(event.pinCode);
        if (orderResponse.success == "1" && orderResponse.data != null)
          yield OrdersLoaded(orderResponse);
        else
          yield OrderError(orderResponse.message);
      } on Error {
        yield OrderError("Something Went Wrong!");
      }

    }

  }

}