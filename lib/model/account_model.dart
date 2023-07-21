class AccountModel {
  String? id;
  String? fullName;
  DateTime? birthday;
  String? email;
  String? gender;
  String? address;
  String? nickname;
  String? password;
  String? imageUrl;
  String? phone;
  String? accountType;

  AccountModel({
    this.id,
    this.fullName,
    this.birthday,
    this.email,
    this.gender,
    this.address,
    this.nickname,
    this.password,
    this.imageUrl,
    this.phone,
    this.accountType,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      fullName: json['fullName'],
      birthday: json['birthday'],
      email: json['email'],
      gender: json['gender'],
      address: json['address'],
      nickname: json['nickname'],
      password: json['password'],
      imageUrl: json['imageUrl'],
      phone: json['phone'],
      accountType: json['accountType'],
    );
  }

  // Convert the User object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'birthday': birthday,
      'email': email,
      'gender': gender,
      'address': address,
      'nickname': nickname,
      'password': password,
      'imageUrl': imageUrl,
      'phone': phone,
      'accountType': accountType,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'birthday': birthday?.toIso8601String(),
      'email': email,
      'gender': gender,
      'address': address,
      'nickname': nickname,
      'password': password,
      'imageUrl': imageUrl,
      'phone': phone,
      'accountType': accountType,
    };
  }
}
