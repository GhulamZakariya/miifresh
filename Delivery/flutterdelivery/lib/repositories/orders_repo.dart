import 'package:flutterdelivery/api/api_provider.dart';
import 'package:flutterdelivery/api/responses/orders_response.dart';

abstract class OrdersRepo {
  Future<OrdersResponse> getOrders(String pinCode);
}

class RealOrdersRepo implements OrdersRepo {
  ApiProvider _apiProvider = ApiProvider();

  @override
  Future<OrdersResponse> getOrders(String pinCode) {
    return _apiProvider.getOrders(pinCode);
  }
}

class FakeOrderRepo implements OrdersRepo {
  @override
  Future<OrdersResponse> getOrders(String pinCode) {
    throw UnimplementedError();
  }
}
