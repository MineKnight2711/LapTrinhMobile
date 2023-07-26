import 'package:intl/intl.dart';

class AccountModel {
  String? id;
  String? fullName;
  DateTime? birthday;
  String? email;
  String? gender;
  String? imageUrl;
  String? phone;

  AccountModel({
    this.id,
    this.fullName,
    this.birthday,
    this.email,
    this.gender,
    this.imageUrl,
    this.phone,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      fullName: json['fullName'],
      birthday: DateFormat('yyyy-MM-dd').parse(json['birthday']),
      email: json['email'],
      gender: json['gender'],
      imageUrl: json['imageUrl'],
      phone: json['phone'],
    );
  }

  // Convert the User object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'birthday':
          birthday != null ? DateFormat("yyyy-MM-dd").format(birthday!) : '',
      'email': email,
      'gender': gender,
      'imageUrl': imageUrl,
      'phone': phone,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'birthday': birthday?.toIso8601String(),
      'email': email,
      'gender': gender,
      'imageUrl': imageUrl,
      'phone': phone,
    };
  }
}
