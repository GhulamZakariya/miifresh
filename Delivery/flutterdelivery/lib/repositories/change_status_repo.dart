import 'package:flutterdelivery/api/api_provider.dart';
import 'package:flutterdelivery/api/responses/change_status_response.dart';

abstract class ChangeStatusRepo {
  Future<ChangeStatusResponse> changeStatus(String status, String pinCode);
}

class RealChangeStatusRepo implements ChangeStatusRepo{
  ApiProvider _apiProvider = ApiProvider();
  @override
  Future<ChangeStatusResponse> changeStatus(String status, String pinCode) {
    return _apiProvider.changeStatus(status, pinCode);
  }
}

class FakeChangeStatusRepo implements ChangeStatusRepo {
  @override
  Future<ChangeStatusResponse> changeStatus(String status, String pinCode) {
    throw UnimplementedError();
  }

}