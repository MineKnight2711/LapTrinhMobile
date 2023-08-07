import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/review_controller.dart';
import 'package:keyboard_mobile_app/model/category_model.dart';
import 'package:keyboard_mobile_app/screens/product/product_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';

import '../../../controller/product_controller.dart';

class ProductList extends StatelessWidget {
  final productControler = Get.find<ProductController>();

  ProductList({super.key, required this.categoryModel});

  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    productControler.getProductByCategory(categoryModel.id);
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                  width: 4,
                  color: Colors.yellow,
                ),
              ),
              const Center(
                  child: Text(
                'Sản phẩm',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              )),
            ],
          ),
        ),
        Flexible(
          child: Obx(
            () {
              if (productControler.listProduct.value != null) {
                return Obx(() {
                  if (productControler.isNoProduct.value == false) {
                    return Container(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 16.0, left: 16.0),
                      child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        showTrailing: false,
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Obx(
                                () => SizedBox(
                                  height: calculateGridViewHeight(
                                      productControler.listProduct.value!
                                          .length, //Số lượng item trong list
                                      productControler
                                          .showMore.value, //Nút xem thêm
                                      150, //Chiều cao của 1 item
                                      2, //Số lượng item theo cột
                                      50, //Khoảng cách ngang giữa các item
                                      70, //Chiều cao của button xem thêm
                                      10), //Chiều cao của widget Divider
                                  child: StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      staggeredTileBuilder: (index) =>
                                          const StaggeredTile.fit(1),
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 8.0,
                                      itemCount: productControler.showMore.value
                                          ? productControler
                                              .listProduct.value!.length
                                          : min(
                                              productControler
                                                  .listProduct.value!.length,
                                              6),
                                      itemBuilder: (context, index) {
                                        final product = productControler
                                            .listProduct.value![index];
                                        return Card(
                                          elevation: 10,
                                          shadowColor:
                                              Colors.grey.withOpacity(1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            child: InkWell(
                                              onTap: () {
                                                final reviewController =
                                                    Get.put(ReviewController());
                                                reviewController.getAllReview(
                                                    "${product.productId}");
                                                slideInTransition(
                                                    context,
                                                    ProductScreen(
                                                        product: product));
                                              },
                                              child: product.displayUrl != null
                                                  ? Hero(
                                                      tag: product.displayUrl ??
                                                          '',
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            product.displayUrl!,
                                                        fit: BoxFit.contain,
                                                      ))
                                                  : const SizedBox.shrink(),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              const Divider(),
                              Obx(
                                () => Visibility(
                                  visible: productControler
                                          .listProduct.value!.length >
                                      6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Toggle the showMore state when the button is pressed
                                      productControler.showMore.value =
                                          !productControler.showMore.value;
                                    },
                                    child: Text(productControler.showMore.value
                                        ? 'Show Less'
                                        : 'Show More'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                        "Chúng tôi chưa cập nhật sản phẩm cho danh mục này"),
                  );
                });
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}

double calculateGridViewHeight(
  int itemCount,
  bool showMore,
  double itemHeight,
  int crossAxisCount,
  double mainAxisSpacing,
  double showMoreButtonHeight,
  double dividerHeight,
) {
  final int maxItemCount = showMore ? itemCount : 6;
  final int rowCount = (maxItemCount + crossAxisCount - 1) ~/ crossAxisCount;
  final double gridViewHeight = rowCount * itemHeight +
      (rowCount - 2) * mainAxisSpacing +
      showMoreButtonHeight +
      dividerHeight;

  return gridViewHeight;
}
