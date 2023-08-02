import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
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
                'Recommended',
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
                      child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (index) =>
                              const StaggeredTile.fit(1),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 8.0,
                          itemCount: productControler.listProduct.value!.length,
                          itemBuilder: (context, index) {
                            final product =
                                productControler.listProduct.value![index];
                            return Card(
                              elevation: 10,
                              shadowColor: Colors.grey.withOpacity(1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                child: InkWell(
                                  onTap: () {
                                    slideInTransition(context,
                                        ProductScreen(product: product));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                            colors: [
                                              Colors.grey.withOpacity(0.3),
                                              Colors.grey.withOpacity(0.7),
                                            ],
                                            center: const Alignment(0, 0),
                                            radius: 0.6,
                                            focal: const Alignment(0, 0),
                                            focalRadius: 0.1),
                                      ),
                                      child: product.displayUrl != null
                                          ? Hero(
                                              tag: product.displayUrl ?? '',
                                              child: CachedNetworkImage(
                                                  imageUrl:
                                                      product.displayUrl!))
                                          : const SizedBox.shrink()),
                                ),
                              ),
                            );
                          }),
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
