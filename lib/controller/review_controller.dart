import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/api/review_api.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:keyboard_mobile_app/model/review_model.dart';
import 'package:logger/logger.dart';

class ReviewController extends GetxController {
  late ReviewApi reviewApi;

  Rx<List<ReviewModel>?> listReview = Rx<List<ReviewModel>?>(null);

  final accountApi = Get.find<AccountApi>();

  final commentController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    reviewApi = Get.put(ReviewApi());
  }

  //Chờ thông tin người dùng hiện tại
  Future<AccountResponse?> awaitCurrentAccount() async {
    return await accountApi.fetchCurrent().then((currentAccount) {
      if (currentAccount != null) {
        return currentAccount;
      }
      return null;
    });
  }

  Future<bool> checkAccountReview() async {
    final currentAccount = await awaitCurrentAccount();

    if (listReview.value != null) {
      for (var review in listReview.value!) {
        if (review.accountId == currentAccount?.accountId) {
          return true;
        }
      }
    }

    return false;
  }

  Future getAllReview(String productId) async {
    final respone = await reviewApi.getAllReviewsOfProduct(productId);
    if (respone.data != null) {
      final reviewReceived = respone.data as List<dynamic>;

      List<ReviewModel> reviewList = reviewReceived
          .map(
            (reviewMap) => ReviewModel.fromJson(reviewMap),
          )
          .toList();
      listReview.value = reviewList;
      Logger().i("${listReview.value?.length} test listReview");
      // isNoProduct.value = false;
    }
  }

  Future<AccountResponse?> getAcconutById(String accountId) async {
    final respone = await accountApi.findAccountById(accountId);
    if (respone.data != null) {
      Logger().i("${respone.data.toString()} get account");
      return AccountResponse.fromJson(respone.data);
    }
    return null;
  }

  RxDouble calculateScore() {
    if (listReview.value != null && listReview.value!.isNotEmpty) {
      double totalScore = listReview.value!.fold(
        0.0,
        (sum, item) => sum + (item.star ?? 0.0),
      );
      int reviewCount = listReview.value!.length;

      if (reviewCount > 0) {
        double averageScore = totalScore / reviewCount;
        return RxDouble(averageScore);
      }
    }

    return RxDouble(0.0);
  }

  final score = 5.0.obs;

  void onFinishReviewed() {
    commentController.clear();
    score.value = 5.0;
  }

  Future<String> addReview(String accountId, String productId) async {
    ReviewModel newReview = ReviewModel();
    newReview.accountId = accountId;
    newReview.dateReview = DateTime.now();
    newReview.productId = productId;
    newReview.star = score.value;
    newReview.comment = commentController.text;
    final respone = await reviewApi.addReview(newReview);
    if (respone.message!.contains("success")) {
      return "Success";
    } else {
      return "${respone.message}";
    }
  }
}
