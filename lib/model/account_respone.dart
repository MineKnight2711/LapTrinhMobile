import 'package:intl/intl.dart';

import 'account_model.dart';

class AccountResponse {
  String? accountId;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? gender;
  bool? isFingerPrintAuthentication;
  DateTime? birthday;
  String? address;
  String? nickname;
  String? status;
  String? imageUrl;
  AccountResponse(
      {this.accountId,
      this.fullName,
      this.phoneNumber,
      this.email,
      this.gender,
      this.isFingerPrintAuthentication,
      this.imageUrl,
      this.birthday,
      this.address,
      this.status});

  AccountResponse.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    fullName = json['fullName'];
    imageUrl = json['imageUrl'];
    phoneNumber = json['phone'];
    email = json['email'];
    gender = json['gender'];
    isFingerPrintAuthentication = json['isFingerPrintAuthentication'];
    birthday =
        json['birthday'] != null ? DateTime.parse(json['birthday']) : null;
    ;
    address = json['address'];
    status = json['status'];
  }
  factory AccountResponse.fromMap(Map<String, dynamic>? map) {
    return AccountResponse(
      accountId: map?['accountId'],
      fullName: map?['fullName'],
      imageUrl: map?['imageUrl'],
      phoneNumber: map?['phone'],
      email: map?['email'],
      gender: map?['gender'],
      isFingerPrintAuthentication: map?['isFingerPrintAuthentication'],
      birthday:
          map?['birthday'] != null ? DateTime.parse(map?['birthday']) : null,
      address: map?['address'],
      status: map?['status'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['fullName'] = fullName;
    data['phone'] = phoneNumber;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    data['gender'] = gender;
    data['isFingerPrintAuthentication'] = isFingerPrintAuthentication;
    data['birthday'] =
        birthday != null ? DateFormat("yyyy-MM-dd").format(birthday!) : '';
    data['status'] = status;
    return data;
  }

  AccountModel toAccountModel() {
    return AccountModel(
      accountId: accountId.toString(),
      fullName: fullName,
      birthday: birthday,
      isFingerPrintAuthentication: isFingerPrintAuthentication,
      email: email,
      gender: gender,
      imageUrl: imageUrl,
      phone: phoneNumber,
    );
  }
}
