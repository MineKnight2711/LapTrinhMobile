class ProductModel {
  String? productId;
  String? productName;
  int? quantity;
  String? unit;
  String? description;
  String? displayUrl;
  String? category;
  String? brand;

  ProductModel({
    this.productId,
    this.productName,
    this.quantity,
    this.unit,
    this.description,
    this.displayUrl,
    this.category,
    this.brand,
  });

  // Factory method to create a ProductModel from JSON data
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unit: json['unit'],
      description: json['description'],
      displayUrl: json['displayUrl'],
      category: json['category'],
      brand: json['brand'],
    );
  }

  // Method to convert a ProductModel to a JSON object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['description'] = description;
    data['displayUrl'] = displayUrl;
    data['category'] = category;
    data['brand'] = brand;
    return data;
  }
}
