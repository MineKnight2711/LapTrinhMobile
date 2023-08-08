class OrderModel {
  String? orderId;
  String? accountId;
  String? receiverInfo;
  DateTime? orderDate;
  DateTime? deliveryDate;
  String? status;

  OrderModel({
    this.orderId,
    this.accountId,
    this.receiverInfo,
    this.orderDate,
    this.deliveryDate,
    this.status,
  });

  // Create an OrderModel instance from a JSON object
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      accountId: json['accountId'],
      receiverInfo: json['receiverInfo'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      status: json['status'],
    );
  }
}
