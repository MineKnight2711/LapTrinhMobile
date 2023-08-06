class AddressModel {
  String? addressId;
  String? accountId;
  String? address;
  String? receiverName;
  String? receiverPhone;
  bool? defaultAddress;

  AddressModel({
    this.addressId,
    this.accountId,
    this.address,
    this.receiverName,
    this.receiverPhone,
    this.defaultAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['addressId'],
      accountId: json['accountId'],
      address: json['address'],
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
      defaultAddress: json['defaultAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'addressId': addressId,
      // 'accountId': accountId,
      'address': address,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'defaultAddress': defaultAddress.toString(),
    };
  }
}
