import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/screens/product/components/color_selected.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

import '../../../widgets/custom_widgets/custom_button.dart';
import '../../../widgets/custom_widgets/message.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final ProductModel product;
  final cartController = Get.put(CartController());
  // final accountController = Get.find<AccountApi>();

  ProductDetailsBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.91,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.aspectRatio * 20),
                  child: Center(
                    child: Text(
                      "${product.productName}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollEdgeListener(
              edge: ScrollEdge.start,
              edgeOffset: 0,
              continuous: false,
              dispatch: true,
              listener: () {
                //Đóng bottom sheet khi người dùng kéo hết cạnh trên của nó
                //Hoạt động không như mong đợi vì 1 số lỗi
                // Navigator.pop(context);
              },
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: mediaHeight(context, 5),
                        child: CachedNetworkImage(
                            imageUrl: "${product.displayUrl}",
                            fit: BoxFit.contain),
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Chọn màu',
                                  style: GoogleFonts.nunito(fontSize: 16),
                                ),
                              ],
                            ),
                            ColorChoiceWidget(
                              onSizeSelected: (value) {
                                cartController.selectedProductDetails.value =
                                    value;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              'Chọn số lượng',
                              style: GoogleFonts.nunito(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
