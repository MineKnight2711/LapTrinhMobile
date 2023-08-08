import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/screens/order_screen/order_screen.dart';
import 'package:lottie/lottie.dart';

import '../../model/product_details_model.dart';
import '../../transition_animation/screen_transition.dart';
import '../../utils/data_convert.dart';
import '../../widgets/custom_widgets/custom_appbar.dart';
import '../../widgets/custom_widgets/message.dart';
import 'components/cart_bottom_nav.dart';
import 'components/edit_cart_bottom_sheet.dart';
import 'components/edit_cart_button.dart';

class CartScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();

  CartScreen({super.key});

  // final orderController = Get.put(CreateOrderController());
  Future<void> refesh() async {
    await cartController.getCartByAccountId();
  }

  @override
  Widget build(BuildContext context) {
    cartController.getCartByAccountId();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          cartController.onClose();
          Navigator.pop(context);
        },
        title: 'Giỏ hàng của tôi',
        backGroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (cartController.listCartItem.isNotEmpty) {
          return Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: cartController.checkedItems.length ==
                            cartController.listCartItem.length,
                        onChanged: (value) {
                          cartController.checkAll(value!, context);
                        },
                      ),
                      const Text('Chọn tất cả'),
                    ],
                  ),
                  const Spacer(),
                  Obx(() {
                    if (cartController.checkedItems.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      width: size.width / 2.3,
                      height: size.height / 24,
                      margin: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                mainButtonColor, // Change the text (label) color here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            String result =
                                await cartController.deleteManyItem();
                            if (result == "Success") {
                              CustomSuccessMessage.showMessage(
                                      "Đã xoá sản phẩm thành công")
                                  .then((value) => cartController
                                      .getCartByAccountId()
                                      .whenComplete(() =>
                                          cartController.calculateCartTotal()));
                            } else {
                              CustomErrorMessage.showMessage(result);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: Obx(
                            () => cartController.checkedItems.length ==
                                    cartController.listCartItem.length
                                ? const Text('Xoá giỏ hàng')
                                : Text(
                                    'Xoá ${cartController.checkedItems.length}'),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: refesh,
                    child: Obx(
                      () => ListView.builder(
                        itemCount: cartController.listCartItem.length,
                        itemBuilder: (context, index) {
                          final item = cartController.listCartItem[index];
                          return Dismissible(
                            key: Key(item.hashCode.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              String result =
                                  await cartController.removeItem(item);
                              if (result == "Success") {
                                CustomSuccessMessage.showMessage(
                                    "Đã xoá sản phẩm thành công");
                              } else {
                                CustomErrorMessage.showMessage(
                                    "Có lỗi xảy ra!");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.1)),
                              height: size.height / 8.5,
                              child: FutureBuilder<ProductDetailModel?>(
                                future: cartController
                                    .getProductByDetail(item.productDetailId!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final detail = snapshot.data;
                                    return FutureBuilder<ProductModel?>(
                                      future: cartController.getProductById(
                                          "${detail?.productId}"),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final product = snapshot.data;
                                          return ListTile(
                                            leading: SizedBox(
                                              height: size.height / 10,
                                              width: size.width / 4,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 1,
                                                    right: 85,
                                                    child: Obx(
                                                      () => Checkbox(
                                                        value: cartController
                                                            .checkedItems
                                                            .contains(item),
                                                        onChanged: (value) {
                                                          cartController
                                                              .checkPerItem(
                                                                  value!,
                                                                  item,
                                                                  context);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      child: SizedBox(
                                                        height:
                                                            size.height / 10,
                                                        width: size.width / 5.5,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${product?.displayUrl}",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            title: SizedBox(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "${product?.productName}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                          child: Text(
                                                        "${detail?.color}",
                                                        style:
                                                            GoogleFonts.nunito(
                                                          color:
                                                              Colors.blue[400],
                                                          fontSize: 14,
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "SL: ${item.quantity}",
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            trailing: Column(
                                              children: [
                                                EditCartItemButton(
                                                  isEnabled: !cartController
                                                      .checkedItems
                                                      .contains(item),
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      builder: (BuildContext
                                                          context) {
                                                        return EditCartItemBottomSheet(
                                                            productDetailModel:
                                                                detail!,
                                                            product: product!,
                                                            cart: item);
                                                      },
                                                    ).then((value) {
                                                      cartController
                                                          .closeBottomSheet();
                                                    });
                                                  },
                                                ),
                                                FutureBuilder<double>(
                                                  future: cartController
                                                      .calculateItemTotal(item),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      double totalForItem =
                                                          snapshot.data!;
                                                      return Text(DataConvert()
                                                          .formatCurrency(
                                                              totalForItem));
                                                    } else {
                                                      return const SizedBox
                                                          .shrink();
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Lottie.asset(
                                          "assets/animations/loading_cart_item_3.json",
                                          width: size.width / 2.5,
                                          height: size.height / 7),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ),
            ],
          );
        }
        return SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2)),
              child: const Center(
                child: Icon(
                  Icons.local_mall_outlined,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            const Text(
              "Giỏ hàng của bạn rỗng\nKhi bạn thêm sản phẩm,\n chúng sẽ xuất hiện ở đây",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  height: 1.2,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.5),
            )
          ]),
        );
      }),
      bottomNavigationBar: Obx(
        () => CartBottomNavigation(
          totalPrice: cartController.totalPrice.value,
          onPaymentPressed: () {
            slideInTransitionReplacement(context, OrderScreen());
          },
        ),
      ),
    );
  }
}
