class ProductDetailModel {
  String? productDetailId;
  String? productId;
  String? color;
  int? price;
  int? quantity;
  String? imageUrl;

  ProductDetailModel({
    this.productDetailId,
    this.productId,
    this.color,
    this.price,
    this.quantity,
    this.imageUrl,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productDetailId: json['productDetailId'],
      productId: json['productId'],
      color: json['color'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productDetailId': productDetailId,
      'productId': productId,
      'color': color,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
