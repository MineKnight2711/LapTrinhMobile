import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
}
