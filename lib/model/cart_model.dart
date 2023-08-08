import 'package:keyboard_mobile_app/model/product_details_model.dart';

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
    data['productDetailId'] = productDetailId;
    data['quantity'] = quantity.toString();
    return data;
  }
}

class CartModel_2 {
  String? accountId;
  ProductDetailModel? productDetail;
  int? quantity;

  CartModel_2({
    this.accountId,
    this.productDetail,
    this.quantity,
  });
}
