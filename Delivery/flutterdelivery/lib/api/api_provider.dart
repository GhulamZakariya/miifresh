import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutterdelivery/api/responses/change_order_status_response.dart';
import 'package:flutterdelivery/api/responses/change_status_response.dart';
import 'package:flutterdelivery/api/responses/login_response.dart';
import 'package:flutterdelivery/api/responses/orders_response.dart';
import 'package:flutterdelivery/api/responses/settings_response.dart';
import 'package:flutterdelivery/constants.dart';

import 'logging_interceptor.dart';

class ApiProvider{
  static final String imageBaseUrl = Constants.ECOMMERCE_URL;
  final String _baseUrl = Constants.ECOMMERCE_URL + "/deliveryboy/";

  final String consumerKey = Constants.CONSUMER_KEY;
  final String consumerSecretKey = Constants.CONSUMER_SECRET;

  Dio _dio;

  ApiProvider() {
    BaseOptions options =
        BaseOptions(receiveTimeout: 15000, connectTimeout: 15000);
    _dio = Dio(options);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var customHeaders = {
        'content-type': 'application/json',
        'consumer-key': "cafc35607735c8b721c9287a9559493d",
        'consumer-secret': "67587c0172853f35dfaa4cb567b991e4",
        'consumer-nonce': getRandomString(32),
        'consumer-device-id': '516598gtv5b346byrj5af1',
        'consumer-ip': '192.168.10.15'
      };
      options.headers.addAll(customHeaders);
      return options;
    }));
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<SettingsResponse> getSettings() async {
    try {
      Response response = await _dio.get(_baseUrl + "setting");
      return SettingsResponse.fromJson(json.decode(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SettingsResponse.withError(_handleError(error));
    }
  }

  Future<LoginResponse> processLogin(String pinCode, String deviceId) async {
    try {
      Response response = await _dio.get(
          _baseUrl + "login?password=" + pinCode + "&device_id=" + deviceId);
      return LoginResponse.fromJson(json.decode(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return LoginResponse.withError(_handleError(error));
    }
  }

  Future<ChangeStatusResponse> changeStatus(String status, String pinCode) async {
    try {
      Response response = await _dio.get(_baseUrl +
          "changestatus?password=" +
          pinCode +
          "&availability_status=" +
          status);
      return ChangeStatusResponse.fromJson(json.decode(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ChangeStatusResponse.withError(_handleError(error));
    }
  }

  Future<OrdersResponse> getOrders(String pinCode) async {
    try {
      Response response = await _dio
          .get(_baseUrl + "orders?password=" + pinCode + "&language_id=1");
      return OrdersResponse.fromJson(json.decode(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return OrdersResponse.withError(_handleError(error));
    }
  }

  Future<ChangeOrderStatusResponse> changeOrderStatus (String orderId, String orderStatus, String comment, String pinCode) async {
    try {
      Response response = await _dio
          .get(_baseUrl + "changeorderstatus?password=" + pinCode + "&orders_id="+ orderId + "&orders_status_id=" + orderStatus +"&");
      return ChangeOrderStatusResponse.fromJson(json.decode(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ChangeOrderStatusResponse.withError(_handleError(error));
    }
  }

  String _handleError(Error error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error as DioError;
      switch (dioError.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
              "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
