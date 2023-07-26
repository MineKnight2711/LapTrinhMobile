import 'package:intl/intl.dart';

class AccountResponse {
  int? accountId;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? gender;
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
      this.imageUrl,
      this.birthday,
      this.address,
      this.status});

  AccountResponse.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    fullName = json['fullName'];
    imageUrl = json['imageUrl'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
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
      phoneNumber: map?['phoneNumber'],
      email: map?['email'],
      gender: map?['gender'],
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
    data['phoneNumber'] = phoneNumber;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    data['gender'] = gender;
    data['birthday'] =
        birthday != null ? DateFormat("yyyy-MM-dd").format(birthday!) : '';
    data['status'] = status;
    return data;
  }
}
