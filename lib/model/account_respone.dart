class AccountResponse {
  int? accountId;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? gender;
  DateTime? birthday;
  String? address;
  String? nickname;
  String? accountType;
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
      this.accountType,
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
    accountType = json['accountType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    data['gender'] = gender;
    data['birthday'] = birthday;
    data['address'] = address;
    data['accountType'] = accountType;
    data['status'] = status;
    return data;
  }
}
