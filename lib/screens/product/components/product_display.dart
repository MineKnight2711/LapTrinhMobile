import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';

import 'image_view.dart';

class ProductDisplay extends StatelessWidget {
  final ProductModel product;
  final List<ProductDetailModel> listProductDetail;
  final productController = Get.find<ProductController>();
  ProductDisplay({
    super.key,
    required this.product,
    required this.listProductDetail,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaWidth(context, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: mediaHeight(context, 3.5),
              child: Obx(
                () {
                  if (productController.listImageUrl.value.isNotEmpty) {
                    int itemNumber =
                        productController.listImageUrl.value.length;
                    return Swiper(
                      itemCount: itemNumber,
                      scrollDirection: Axis.horizontal,
                      physics: itemNumber > 1
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),

                      viewportFraction: itemNumber > 1
                          ? 0.75
                          : 1, // Set the fraction of the viewport that each item occupies
                      scale: itemNumber > 1 ? 0.7 : 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              SizedBox(
                                height: mediaHeight(context, 80),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ImageViewDialog(
                                          imageUrl:
                                              product.displayUrl.toString());
                                    },
                                  );
                                },
                                child: Container(
                                  height: mediaHeight(context, 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 3, spreadRadius: 1)
                                      ]),
                                  child: Hero(
                                    tag: "${product.displayUrl}",
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: "${product.displayUrl}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: mediaHeight(context, 80),
                              ),
                            ],
                          );
                        } else {
                          final imageUrl =
                              productController.listImageUrl.value[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: mediaHeight(context, 80),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ImageViewDialog(
                                          imageUrl: imageUrl);
                                    },
                                  );
                                },
                                child: Container(
                                  height: mediaHeight(context, 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 3, spreadRadius: 1)
                                      ]),
                                  child: Hero(
                                    tag: imageUrl,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: mediaHeight(context, 80),
                              ),
                            ],
                          );
                        }
                      },
                      pagination: const SwiperPagination(
                        builder: FractionPaginationBuilder(
                            fontSize: 12,
                            activeFontSize: 16,
                            activeColor: Colors.black,
                            color: Colors.black),

                        alignment: Alignment.bottomRight,
                        margin:
                            EdgeInsets.all(10.0), // Adjust margins as needed
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )),
          SizedBox(
            height: mediaHeight(context, 70),
          ),
        ],
      ),
    );
  }
}
