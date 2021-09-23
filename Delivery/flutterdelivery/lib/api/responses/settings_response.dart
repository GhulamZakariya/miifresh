import 'package:flutterdelivery/models/settings.dart';

class SettingsResponse {
  String success;
  Settings data;
  String message;

  SettingsResponse({this.success, this.data, this.message});

  SettingsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Settings.fromJson(json['data']) : null;
    message = json['message'];
  }

  SettingsResponse.withError(String error) {
    success = "0";
    data = null;
    message = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}