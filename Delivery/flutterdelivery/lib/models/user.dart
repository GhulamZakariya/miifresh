class User {
  String id;
  String roleId;
  String userName;
  String firstName;
  String lastName;
  String gender;
  String defaultAddressId;
  String countryCode;
  String phone;
  String email;
  String password;
  String avatar;
  String status;
  String isSeen;
  String phoneVerified;
  String rememberToken;
  String authIdTiwilo;
  String dob;
  String createdAt;
  String updatedAt;
  String deliveryboyInfoId;
  String usersId;
  String bloodGroup;
  String bikeName;
  String bikeDetails;
  String bikeColor;
  String ownerName;
  String vehicleRegistrationNumber;
  String drivingLicenseImage;
  String vehicleRcBookImage;
  String availabilityStatus;
  String commission;
  String bankDetailId;
  String bankName;
  String bankAccountNumber;
  String bankRoutingNumber;
  String bankAddress;
  String bankIban;
  String bankSwift;
  String isCurrent;
  int balance;
  int flostingCash;

  User(
      {this.id,
        this.roleId,
        this.userName,
        this.firstName,
        this.lastName,
        this.gender,
        this.defaultAddressId,
        this.countryCode,
        this.phone,
        this.email,
        this.password,
        this.avatar,
        this.status,
        this.isSeen,
        this.phoneVerified,
        this.rememberToken,
        this.authIdTiwilo,
        this.dob,
        this.createdAt,
        this.updatedAt,
        this.deliveryboyInfoId,
        this.usersId,
        this.bloodGroup,
        this.bikeName,
        this.bikeDetails,
        this.bikeColor,
        this.ownerName,
        this.vehicleRegistrationNumber,
        this.drivingLicenseImage,
        this.vehicleRcBookImage,
        this.availabilityStatus,
        this.commission,
        this.bankDetailId,
        this.bankName,
        this.bankAccountNumber,
        this.bankRoutingNumber,
        this.bankAddress,
        this.bankIban,
        this.bankSwift,
        this.isCurrent,
        this.balance,
        this.flostingCash});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    defaultAddressId = json['default_address_id'];
    countryCode = json['country_code'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    status = json['status'];
    isSeen = json['is_seen'];
    phoneVerified = json['phone_verified'];
    rememberToken = json['remember_token'];
    authIdTiwilo = json['auth_id_tiwilo'];
    dob = json['dob'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryboyInfoId = json['deliveryboy_info_id'];
    usersId = json['users_id'];
    bloodGroup = json['blood_group'];
    bikeName = json['bike_name'];
    bikeDetails = json['bike_details'];
    bikeColor = json['bike_color'];
    ownerName = json['owner_name'];
    vehicleRegistrationNumber = json['vehicle_registration_number'];
    drivingLicenseImage = json['driving_license_image'];
    vehicleRcBookImage = json['vehicle_rc_book_image'];
    availabilityStatus = json['availability_status'];
    commission = json['commission'];
    bankDetailId = json['bank_detail_id'];
    bankName = json['bank_name'];
    bankAccountNumber = json['bank_account_number'];
    bankRoutingNumber = json['bank_routing_number'];
    bankAddress = json['bank_address'];
    bankIban = json['bank_iban'];
    bankSwift = json['bank_swift'];
    isCurrent = json['is_current'];
    balance = json['balance'];
    flostingCash = json['flosting_cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['default_address_id'] = this.defaultAddressId;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['status'] = this.status;
    data['is_seen'] = this.isSeen;
    data['phone_verified'] = this.phoneVerified;
    data['remember_token'] = this.rememberToken;
    data['auth_id_tiwilo'] = this.authIdTiwilo;
    data['dob'] = this.dob;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deliveryboy_info_id'] = this.deliveryboyInfoId;
    data['users_id'] = this.usersId;
    data['blood_group'] = this.bloodGroup;
    data['bike_name'] = this.bikeName;
    data['bike_details'] = this.bikeDetails;
    data['bike_color'] = this.bikeColor;
    data['owner_name'] = this.ownerName;
    data['vehicle_registration_number'] = this.vehicleRegistrationNumber;
    data['driving_license_image'] = this.drivingLicenseImage;
    data['vehicle_rc_book_image'] = this.vehicleRcBookImage;
    data['availability_status'] = this.availabilityStatus;
    data['commission'] = this.commission;
    data['bank_detail_id'] = this.bankDetailId;
    data['bank_name'] = this.bankName;
    data['bank_account_number'] = this.bankAccountNumber;
    data['bank_routing_number'] = this.bankRoutingNumber;
    data['bank_address'] = this.bankAddress;
    data['bank_iban'] = this.bankIban;
    data['bank_swift'] = this.bankSwift;
    data['is_current'] = this.isCurrent;
    data['balance'] = this.balance;
    data['flosting_cash'] = this.flostingCash;
    return data;
  }
}