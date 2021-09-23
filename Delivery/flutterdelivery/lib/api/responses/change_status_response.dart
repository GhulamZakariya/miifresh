class ChangeStatusResponse {
  String success;
  String data;
  String message;

  ChangeStatusResponse({this.success, this.data, this.message});

  ChangeStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  ChangeStatusResponse.withError(String error) {
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