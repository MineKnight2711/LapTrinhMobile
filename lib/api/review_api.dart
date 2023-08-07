import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:keyboard_mobile_app/model/review_model.dart';
import 'package:logger/logger.dart';

import '../base_url_api.dart';

class ReviewApi extends GetxController {
  Future<ResponseBaseModel> getAllReviewsOfProduct(String productId) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiGetAllReview}/$productId");

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

  Future<ResponseBaseModel> addReview(ReviewModel review) async {
    ResponseBaseModel responseBaseModel = ResponseBaseModel();
    final url = Uri.parse("${ApiUrl.apiCreateReview}/${review.accountId}");
    Logger().i("${review.toJson()} log review");
    final body = review.toJson();
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
}
