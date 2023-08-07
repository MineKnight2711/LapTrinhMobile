// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/model/cart_model.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/screens/product/components/quantity_selector.dart';
import '../../../configs/mediaquery.dart';
import '../../../controller/cart_controller.dart';
import '../../../utils/show_animations.dart';
import '../../../widgets/custom_widgets/custom_button.dart';
import '../../../widgets/custom_widgets/custom_swiper_panation.dart';
import '../../../widgets/custom_widgets/message.dart';

class EditCartItemBottomSheet extends StatefulWidget {
  final ProductModel product;
  final ProductDetailModel productDetailModel;
  final CartModel cart;
  const EditCartItemBottomSheet(
      {super.key,
      required this.cart,
      required this.product,
      required this.productDetailModel});

  @override
  State<EditCartItemBottomSheet> createState() =>
      _EditCartItemBottomSheetState();
}

class _EditCartItemBottomSheetState extends State<EditCartItemBottomSheet> {
  final cartController = Get.find<CartController>();
  late String? selectedProductDetails;
  late int? currentQuantity;

  @override
  void initState() {
    super.initState();
    selectedProductDetails = widget.cart.productDetailId;
    currentQuantity = widget.cart.quantity;
  }

  @override
  Widget build(BuildContext context) {
    cartController.getProductByDetail(selectedProductDetails!);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      child: SingleChildScrollView(
        child: Column(children: [
          Stack(children: [
            Center(
              child: SizedBox(
                height: mediaHeight(context, 14),
                width: mediaWidth(context, 1.4),
                child: Text(
                  "${widget.product.productName}",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(fontSize: 18),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ),
            ),
          ]),
          Obx(() {
            if (cartController.listImageUrl.isEmpty) {
              return Container(
                height: mediaHeight(context, 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(blurRadius: 3, spreadRadius: 1)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: "${widget.product.displayUrl}",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              final listImageUrl = cartController.listImageUrl;
              return SizedBox(
                width: double.infinity,
                height: mediaHeight(context, 5),
                child: Swiper(
                  itemCount: listImageUrl.length,
                  physics: listImageUrl.length > 1
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = listImageUrl[index];
                    return SizedBox(
                      height: mediaHeight(context, 4),
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        imageUrl: item,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  pagination: SwiperCustomPagination(
                    builder: (context, config) {
                      return CustomSwiperPagination(
                          itemCount: listImageUrl.length,
                          activeIndex: config.activeIndex);
                    },
                  ),
                ),
              );
            }
          }),
          Divider(
            color: Colors.black.withOpacity(0.2),
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                const Text(
                  'Số lượng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.8,
                  child: QuantitySelector(
                    maxQuantity: widget.productDetailModel.quantity ??
                        0, //Sửa lại chỗ này
                    initialValue: widget.cart.quantity ?? 0,
                    onValueChanged: (value) {
                      currentQuantity = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.2),
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: DefaultButton(
              press: () async {
                CartModel updateCart = widget.cart;
                updateCart.quantity = currentQuantity;
                String result = await cartController.updateCart(updateCart);
                switch (result) {
                  case "Success":
                    CustomSuccessMessage.showMessage(
                        "Cập nhật giỏ hàng thành công!");
                    showLoadingAnimation(context,
                            "assets/animations/add_to_cart.json", 160, 2)
                        .then((_) {
                      cartController.checkedItems.clear();
                      cartController.getCartByAccountId().whenComplete(
                            () => Navigator.pop(context),
                          );
                    });
                    break;
                  case "Fail":
                    CustomErrorMessage.showMessage(
                        "Không thể thêm vào giỏ hàng!");
                    break;
                  case "NoUser":
                    CustomErrorMessage.showMessage(
                        "Phiên đăng nhập không hợp lệ!\nVui lòng đăng nhập lại!");
                    break;
                  default:
                    CustomErrorMessage.showMessage("Lỗi không xác định!");
                    break;
                }
              },
              text: "Lưu",
            ),
          )
        ]),
      ),
    );
  }
}
