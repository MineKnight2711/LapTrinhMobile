import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/address_model.dart';
import 'package:logger/logger.dart';
import '../base_url_api.dart';
import '../model/respone_base_model.dart';

class AddressApi extends GetxController {
  Future<ResponseBaseModel> getAddressesByAccount(String accountId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiGetAddressByAccountId}/$accountId");
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

  Future<ResponseBaseModel> addAddress(AddressModel address) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiAddAddress}/${address.accountId}");
    Logger().i("${address.toJson()}");
    final body = address.toJson();
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

  Future<ResponseBaseModel> deleteAddress(String addressId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiDeleteAddress}/$addressId");
    Logger().i("$addressId log addressId");
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

  Future<ResponseBaseModel> updateAddress(AddressModel currentAddress) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url =
        Uri.parse("${ApiUrl.apiUpdateAddress}/${currentAddress.addressId}");
    Logger().i("${currentAddress.toJson()} log update address");
    final body = currentAddress.toJson();
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
}
