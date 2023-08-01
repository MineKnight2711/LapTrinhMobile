import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:logger/logger.dart';

import '../../../utils/data_convert.dart';

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
          // Container(
          //   color: Colors.black,
          //   child: Hero(
          //     tag: "${product.displayUrl}",
          //     child: Image.network(
          //       "${product.displayUrl}",
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SizedBox(
              height: mediaHeight(context, 2.5),
              child: Obx(
                () {
                  if (productController.listImageUrl.value.isNotEmpty) {
                    print(productController.listImageUrl.value.length);
                    return Swiper(
                      itemCount: productController.listImageUrl.value.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            color: Colors.black,
                            child: Hero(
                              tag: "${product.displayUrl}",
                              child: CachedNetworkImage(
                                imageUrl: "${product.displayUrl}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          final imageUrl =
                              productController.listImageUrl.value[index];
                          return Container(
                            color: Colors.black,
                            child: Hero(
                              tag: imageUrl,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )),
        ],
      ),
    );
  }
}
