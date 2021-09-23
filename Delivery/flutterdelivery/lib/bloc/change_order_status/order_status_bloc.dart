import 'package:bloc/bloc.dart';
import 'package:flutterdelivery/api/responses/change_order_status_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterdelivery/repositories/order_status_repo.dart';

part 'order_status_event.dart';

part 'order_status_state.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState>{

  final OrderStatusRepo statusRepo;

  OrderStatusBloc(this.statusRepo) : super(OrderStatusInitial());

  @override
  Stream<OrderStatusState> mapEventToState(OrderStatusEvent event) async*  {
    if (event is ChangeOrderStatus) {
      try {
        final orderStatusResponse = await statusRepo.changeOrderStatus(event.orderId, event.orderStatusId, event.comment, event.pinCode);
        if (orderStatusResponse.success == "1")
          yield OrderStatusLoaded(orderStatusResponse);
        else
          yield OrderStatusError(orderStatusResponse.message);
      } on Error {
        yield OrderStatusError("Something went wrong");
      }
    }
  }
}