import 'package:flutterdelivery/models/order.dart';

class OrdersResponse {
  String success;
  List<Order> data;
  String message;

  OrdersResponse({this.success, this.data, this.message});

  OrdersResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Order.fromJson(v));
      });
    }
    message = json['message'];
  }

  OrdersResponse.withError(String error) {
    success = "0";
    data = null;
    message = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}