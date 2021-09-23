import 'package:flutterdelivery/api/responses/login_response.dart';

import '../api/api_provider.dart';

abstract class LoginRepo {
  Future<LoginResponse> getLoginResponse(String pinCode, String deviceId);
}

class RealLoginRepo implements LoginRepo {
  ApiProvider _apiProvider = ApiProvider();

  @override
  Future<LoginResponse> getLoginResponse(String pinCode, String deviceId) {
    return _apiProvider.processLogin(pinCode, deviceId);
  }
}

class FakeLoginRepo implements LoginRepo {
  @override
  Future<LoginResponse> getLoginResponse(String pinCode, String deviceId) {
    throw UnimplementedError();
  }
}
