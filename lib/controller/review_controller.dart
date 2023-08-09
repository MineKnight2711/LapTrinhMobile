import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/api/review_api.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/model/review_model.dart';
import 'package:logger/logger.dart';

class ReviewController extends GetxController {
  late ReviewApi reviewApi;

  Rx<List<ReviewModel>?> listReview = Rx<List<ReviewModel>?>(null);

  final accountApi = Get.find<AccountApi>();

  final commentController = TextEditingController();

  final isValidReview = true.obs;
  @override
  void onInit() {
    super.onInit();
    reviewApi = Get.put(ReviewApi());
  }

  bool checkAccount(String accountId) {
    if (accountApi.accountRespone.value != null) {
      if (accountApi.accountRespone.value!.accountId == accountId) {
        return true;
      }
    }
    return false;
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
      //Lấy account hiện tại
      final currentAccount = await awaitCurrentAccount();

      //Tạo hai list để duyệt với tài khoản hiện tại
      List<ReviewModel> currentUserReviews = [];
      List<ReviewModel> otherUserReviews = [];

      for (var review in reviewList) {
        if (currentAccount != null &&
            review.accountId == currentAccount.accountId) {
          currentUserReviews.add(review);
        } else {
          otherUserReviews.add(review);
        }
      }

      //Sắp xếp danh sách review theo ngày tháng
      otherUserReviews.sort((a, b) => b.dateReview!.compareTo(a.dateReview!));

      // Nối hai danh sách lại với nhau
      listReview.value = [...currentUserReviews, ...otherUserReviews];
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

  String? validateReview(String? fullname) {
    if (fullname!.length >= 50) {
      isValidReview.value = false;
      return 'Đánh giá phải dưới 50 ký tự!';
    }
    isValidReview.value = true;
    return null;
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

  Future<String> deleteReview(String reviewId) async {
    final respone = await reviewApi.deleteReview(reviewId);
    if (respone.message!.contains("deleted")) {
      return "Success";
    } else {
      return "${respone.message}";
    }
  }
}
