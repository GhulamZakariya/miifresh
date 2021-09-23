
import 'package:flutterdelivery/api/api_provider.dart';
import 'package:flutterdelivery/api/responses/change_order_status_response.dart';

abstract class OrderStatusRepo {
  Future<ChangeOrderStatusResponse> changeOrderStatus(String orderId, String orderStatusId, String comment, String pinCode);
}

class RealOrderStatusRepo implements OrderStatusRepo {

  ApiProvider _apiProvider = ApiProvider();

  @override
  Future<ChangeOrderStatusResponse> changeOrderStatus(String orderId, String orderStatusId, String comment, String pinCode) {
    return _apiProvider.changeOrderStatus(orderId, orderStatusId, comment, pinCode);
  }
}

class FakeOrderStatusRepo implements OrderStatusRepo {

  @override
  Future<ChangeOrderStatusResponse> changeOrderStatus(String orderId, String orderStatusId, String comment, String pinCode) {
    throw UnimplementedError();
  }
}