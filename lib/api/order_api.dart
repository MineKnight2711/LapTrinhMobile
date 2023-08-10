import 'dart:convert';

import 'package:get/get.dart';
import 'package:keyboard_mobile_app/base_url_api.dart';
import 'package:keyboard_mobile_app/model/order_model.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:http/http.dart' as http;
import '../model/cart_model.dart';

class OrderApi extends GetxController {
  Future<ResponseBaseModel> saveOrder(
      OrderModel newOrder, List<CartModel> chosenItems) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse(ApiUrl.apiCreateOrder);

    List<Map<String, String>> lstProductDetail = chosenItems.map((item) {
      return {
        "productDetailId": item.productDetailId.toString(),
        "quantity": item.quantity.toString(),
      };
    }).toList();

    Map<String, dynamic> body = {
      "accountId": newOrder.accountId,
      "receiverInfo": newOrder.receiverInfo,
      "lstProduct": lstProductDetail,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }

  Future<ResponseBaseModel> getAndFetchAllOrder(String accountId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiGetAndFetchAllOrder}/$accountId");

    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }

  Future<ResponseBaseModel> updateOrderStatus(
      String orderId, String status) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url =
        Uri.parse("${ApiUrl.apiUpdateOrderStatus}/$orderId?status=$status");

    final response = await http.put(
      url,
    );

    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }
}
