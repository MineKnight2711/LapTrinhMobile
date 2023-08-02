class CartModel {
  String? accountId;
  String? productDetailId;
  int? quantity;

  CartModel({
    this.accountId,
    this.productDetailId,
    this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      accountId: json['accountId'],
      productDetailId: json['productDetailId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['productDetailId'] = productDetailId;
    data['quantity'] = quantity;
    return data;
  }
}
