import 'package:keyboard_mobile_app/utils/data_convert.dart';

class QueryOrder {
  String orderId;
  String accountId;
  double total;
  DateTime orderDate;
  String receiverInfo;
  String status;
  List<QueryOrderDetail> listOrderDetail;

  QueryOrder({
    required this.orderId,
    required this.accountId,
    required this.orderDate,
    this.total = 0.0,
    required this.receiverInfo,
    required this.status,
    required this.listOrderDetail,
  });

  factory QueryOrder.fromJson(Map<String, dynamic> json) {
    return QueryOrder(
      orderId: json['orderId'],
      accountId: json['accountId'],
      orderDate: DateTime.parse(json['orderDate']),
      receiverInfo: json['receiverInfo'],
      status: json['status'],
      listOrderDetail: (json['listOrderDetail'] as List)
          .map((detailJson) => QueryOrderDetail.fromJson(detailJson))
          .toList(),
    );
  }
}

class QueryOrderDetail {
  String orderId;
  QueryProductDetail productDetail;
  int quantity;

  QueryOrderDetail({
    required this.orderId,
    required this.productDetail,
    required this.quantity,
  });

  factory QueryOrderDetail.fromJson(Map<String, dynamic> json) {
    return QueryOrderDetail(
      orderId: json['orderId'],
      productDetail: QueryProductDetail.fromJson(json['productDetail']),
      quantity: json['quantity'],
    );
  }
}

class QueryProductDetail {
  String productDetailId;
  QueryProduct product;
  String color;
  double price;
  int quantity;
  List<String> imageUrl;

  QueryProductDetail({
    required this.productDetailId,
    required this.product,
    required this.color,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory QueryProductDetail.fromJson(Map<String, dynamic> json) {
    return QueryProductDetail(
      productDetailId: json['productDetailId'],
      product: QueryProduct.fromJson(json['product']),
      color: json['color'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: DataConvert().encodeListImages(json['imageUrl']),
    );
  }
}

class QueryProduct {
  String productId;
  String productName;
  int quantity;
  String unit;
  String description;
  String displayUrl;
  String category;
  String brand;

  QueryProduct({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.displayUrl,
    required this.category,
    required this.brand,
  });

  factory QueryProduct.fromJson(Map<String, dynamic> json) {
    return QueryProduct(
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
}
