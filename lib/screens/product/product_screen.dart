import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/screens/product/components/product_bottom_sheet.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';

import '../../controller/product_detail_controller.dart';
import '../../widgets/custom_widgets/rating_bars.dart';
import 'components/product_display.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;
  ProductScreen({super.key, required this.product});
  final productController = Get.find<ProductController>();
  final detailsController = Get.put(ProductDetailController());
  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: mediaHeight(context, 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ShowRatingBar(
                        rating: 4.5,
                        size: 20,
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
                      child: GestureDetector(
                        onTap: () {
                          //Chuyển dến màn hình đánh giá
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                const Center(
                  child: Text(
                    "Chi tiết",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 40.0, bottom: 130),
                  child: Text(
                    "${product.description}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: "NunitoSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
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
