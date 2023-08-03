import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/cart_model.dart';

import '../base_url_api.dart';
import '../model/respone_base_model.dart';

class CartApi extends GetxController {
  Future<ResponseBaseModel> addToCart(CartModel cartItem) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiAddToCart}/${cartItem.accountId}");
    final body = cartItem.toJson();
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }

  Future<ResponseBaseModel> updateCart(CartModel cartItem) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiUpdateCart}/${cartItem.accountId}");
    final body = cartItem.toJson();
    final response = await http.put(url, body: body);
    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }

  Future<ResponseBaseModel> clearCart(String accountId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiClearCart}/$accountId");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }

  Future getCartByAccountId(String? accountId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiGetCartByAccount}/$accountId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      responseBaseModel.message = "Success";
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }

  Future deleteFromCart(String? accountId, String? productDetailsId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse(
        "${ApiUrl.apiDeleteItemFromCart}/$accountId?productDetailId=$productDetailsId");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      responseBaseModel.message = "Success";
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }
}
