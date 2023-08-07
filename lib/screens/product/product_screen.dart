// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/screens/product/components/product_bottom_sheet.dart';
import 'package:keyboard_mobile_app/screens/product/rating/rating_dialog.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../controller/product_detail_controller.dart';
import '../../controller/review_controller.dart';
import '../../model/review_model.dart';
import '../../widgets/custom_widgets/rating_bars.dart';
import 'components/product_display.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;
  ProductScreen({super.key, required this.product});
  final productController = Get.find<ProductController>();
  final detailsController = Get.put(ProductDetailController());
  final reviewController = Get.find<ReviewController>();
  @override
  Widget build(BuildContext context) {
    var menu = ["Mô tả", "Nhận xét"];
    productController.getProductDetails("${product.productId}");
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        title: "${product.productName}",
        backGroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mediaHeight(context, 70),
                ),
                Obx(
                  () {
                    if (productController.listProductDetails.value != null) {
                      final listProductDetails =
                          productController.listProductDetails.value!;
                      return ProductDisplay(
                        product: product,
                        listProductDetail: listProductDetails,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                Container(
                  height: mediaHeight(context, 1),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey,
                            offset: Offset(1, 0)),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: mediaHeight(context, 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Obx(
                                  () => ShowRatingBar(
                                    rating:
                                        reviewController.calculateScore().value,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 3, left: 5),
                                  child: Obx(
                                    () => Text(
                                      reviewController
                                          .calculateScore()
                                          .value
                                          .toStringAsFixed(1),
                                      style: GoogleFonts.nunito(fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: mediaWidth(context, 3),
                            height: mediaHeight(context, 20),
                            decoration: const BoxDecoration(
                              color: mainButtonColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final currentAccount = await reviewController
                                    .awaitCurrentAccount();
                                if (currentAccount != null) {
                                  final checkAccount = await reviewController
                                      .checkAccountReview();
                                  if (!checkAccount) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ProductRatingDialog(
                                          product: product,
                                        );
                                      },
                                    );
                                  } else {
                                    CustomErrorMessage.showMessage(
                                        "Bạn đã đánh giá sản phẩm này rồi!");
                                  }
                                } else {
                                  CustomErrorMessage.showMessage(
                                      "Bạn phải đăng nhập để đánh giá");
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.star, color: Colors.white),
                                  SizedBox(
                                    width: mediaWidth(context, 120),
                                  ),
                                  const Text("Đánh giá")
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mediaHeight(context, 30),
                      ),
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(menu.length, (index) {
                              var item = menu[index];
                              return InkWell(
                                onTap: () {
                                  productController.selected.value = index;
                                },
                                child: SizedBox(
                                  height: 100.0,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(item,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                      const Spacer(),
                                      (productController.selected.value ==
                                              index)
                                          ? Container(
                                              height: 2.0,
                                              decoration: const BoxDecoration(
                                                color: Color(0xff01A688),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    16.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 20.0, right: 40.0, bottom: 130),
                      //   child: Text(
                      //     "${product.description}",
                      //     style: GoogleFonts.roboto(
                      //         fontWeight: FontWeight.w400,
                      //         fontStyle: FontStyle.normal,
                      //         fontSize: 16.0),
                      //   ),
                      // ),
                      Obx(
                        () => IndexedStack(
                            index: productController.selected.value,
                            children: [
                              Container(
                                decoration: const BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 22.0,
                                    ),
                                    SizedBox(
                                      height: 128,
                                      child: Text("${product.description}"),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() {
                                if (reviewController.listReview.value != null) {
                                  return Column(
                                    children: reviewController.listReview.value!
                                        .map((review) =>
                                            ReviewCard(review: review))
                                        .toList(),
                                  );
                                } else {
                                  reviewController
                                      .getAllReview("${product.productId}");
                                  return const Center(
                                    child: Text("Loading..."),
                                  );
                                }
                              }),
                            ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: DefaultButton(
          text: "Xem chi tiết",
          press: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return ProductDetailsBottomSheet(
                  product: product,
                );
              },
            ).then((value) => detailsController.onClose());
          },
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  ReviewCard({super.key, required this.review});
  final reviewController = Get.find<ReviewController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: mediaHeight(context, 6),
        width: mediaWidth(context, 1),
        child: FutureBuilder<AccountResponse?>(
          future: reviewController.getAcconutById("${review.accountId}"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: mediaHeight(context, 9),
                    width: mediaWidth(context, 1),
                    child: ListTile(
                      leading: SizedBox(
                        height: mediaHeight(context, 9),
                        width: mediaWidth(context, 6),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.imageUrl.toString(),
                        ),
                      ),
                      title: Text("${snapshot.data?.fullName}"),
                      subtitle: Row(
                        children: [
                          ShowRatingBar(
                            rating: review.star ?? 0.0,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Text(
                              review.star.toString(),
                              style: GoogleFonts.nunito(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: mediaHeight(context, 200),
                  // ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "${review.comment}",
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
