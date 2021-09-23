class ChangeOrderStatusResponse {
  String success;
  String data;
  String message;

  ChangeOrderStatusResponse({this.success, this.data, this.message});

  ChangeOrderStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  ChangeOrderStatusResponse.withError(String error) {
    success = "0";
    data = "";
    message = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
