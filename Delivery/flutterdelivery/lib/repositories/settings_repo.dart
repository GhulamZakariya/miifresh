import 'package:flutterdelivery/api/api_provider.dart';
import 'package:flutterdelivery/api/responses/settings_response.dart';

abstract class ServerSettingsRepo {
  Future<SettingsResponse> fetchServerSettings();
}

class RealServerSettingsRepo implements ServerSettingsRepo {

  ApiProvider _apiProvider = ApiProvider();

  @override
  Future<SettingsResponse> fetchServerSettings() {
    return _apiProvider.getSettings();
  }

}

class FakeServeSettingsRepo implements ServerSettingsRepo {

  @override
  Future<SettingsResponse> fetchServerSettings() {
    throw UnimplementedError();
  }

}