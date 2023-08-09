import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/review_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

class ProductRatingDialog extends StatelessWidget {
  final ProductModel product;

  final reviewController = Get.find<ReviewController>();

  ProductRatingDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.center,
        child: Text('Đánh giá ${product.productName}'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sản phẩm này chất chứ ?'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  allowHalfRating: true,
                  unratedColor: Colors.grey,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  updateOnDrag: true,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingvalue) {
                    reviewController.score.value = ratingvalue;
                  },
                ),
              ),
              Obx(
                () => Text(
                  '${reviewController.score.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: mediaWidth(context, 1.5),
            height: mediaHeight(context, 9),
            child: CustomInputTextField(
              maxLenght: 50,
              controller: reviewController.commentController,
              hintText: "Cảm nhận của bạn",
              onChanged: reviewController.validateReview,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Huỷ'),
          onPressed: () {
            reviewController.onFinishReviewed();
            Navigator.of(context).pop();
          },
        ),
        Obx(
          () => ElevatedButton(
            onPressed: reviewController.isValidReview.value
                ? () async {
                    final currentAccount =
                        await reviewController.awaitCurrentAccount();
                    if (currentAccount != null) {
                      final result = await reviewController.addReview(
                          "${currentAccount.accountId}",
                          "${product.productId}");
                      if (result == "Success") {
                        CustomSuccessMessage.showMessage("Đánh giá thành công!")
                            .then((value) {
                          reviewController
                              .getAllReview("${product.productId}")
                              .then((value) {
                            reviewController.onFinishReviewed();
                            Navigator.pop(context);
                          });
                        });
                      } else {
                        CustomErrorMessage.showMessage(result);
                      }
                    } else {
                      CustomErrorMessage.showMessage(
                          "Phiên đăng nhập không hợp lệ!");
                    }
                  }
                : null,
            child: const Text('Gửi'),
          ),
        ),
      ],
    );
  }
}
