import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../base_url_api.dart';
import '../model/respone_base_model.dart';

class ProductApi extends GetxController {
  Future<ResponseBaseModel> getProductByCategory(String? categoryId) async {
    print(categoryId);
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiGetProductByCategory}/$categoryId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      responseBaseModel = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      print(responseBaseModel.toJson());
      responseBaseModel.message = "Success";
      return responseBaseModel;
    } else {
      responseBaseModel.message = "Fail";
      return responseBaseModel;
    }
  }
}
