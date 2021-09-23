class Settings {
  String authDomain;
  String currencySymbol;
  String databaseURL;
  String defaultLatitude;
  String defaultLongitude;
  String firebaseApikey;
  String firebaseAppid;
  String googleMapApi;
  String isEnableLocation;
  String maptype;
  String messagingSenderid;
  String onesignalAppId;
  String onesignalSenderId;
  String projectId;
  String storageBucket;

  Settings(
      {this.authDomain,
        this.currencySymbol,
        this.databaseURL,
        this.defaultLatitude,
        this.defaultLongitude,
        this.firebaseApikey,
        this.firebaseAppid,
        this.googleMapApi,
        this.isEnableLocation,
        this.maptype,
        this.messagingSenderid,
        this.onesignalAppId,
        this.onesignalSenderId,
        this.projectId,
        this.storageBucket});

  Settings.fromJson(Map<String, dynamic> json) {
    authDomain = json['auth_domain'];
    currencySymbol = json['currency_symbol'];
    databaseURL = json['database_URL'];
    defaultLatitude = json['default_latitude'];
    defaultLongitude = json['default_longitude'];
    firebaseApikey = json['firebase_apikey'];
    firebaseAppid = json['firebase_appid'];
    googleMapApi = json['google_map_api'];
    isEnableLocation = json['is_enable_location'];
    maptype = json['maptype'];
    messagingSenderid = json['messaging_senderid'];
    onesignalAppId = json['onesignal_app_id'];
    onesignalSenderId = json['onesignal_sender_id'];
    projectId = json['projectId'];
    storageBucket = json['storage_bucket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_domain'] = this.authDomain;
    data['currency_symbol'] = this.currencySymbol;
    data['database_URL'] = this.databaseURL;
    data['default_latitude'] = this.defaultLatitude;
    data['default_longitude'] = this.defaultLongitude;
    data['firebase_apikey'] = this.firebaseApikey;
    data['firebase_appid'] = this.firebaseAppid;
    data['google_map_api'] = this.googleMapApi;
    data['is_enable_location'] = this.isEnableLocation;
    data['maptype'] = this.maptype;
    data['messaging_senderid'] = this.messagingSenderid;
    data['onesignal_app_id'] = this.onesignalAppId;
    data['onesignal_sender_id'] = this.onesignalSenderId;
    data['projectId'] = this.projectId;
    data['storage_bucket'] = this.storageBucket;
    return data;
  }
}
