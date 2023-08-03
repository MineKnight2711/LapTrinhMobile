import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';

import '../../model/product_details_model.dart';
import '../../utils/data_convert.dart';
import '../../widgets/custom_widgets/custom_appbar.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/message.dart';
import 'components/cart_bottom_nav.dart';
import 'components/edit_cart_bottom_sheet.dart';
import 'components/edit_cart_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartController = Get.find<CartController>();

  // final orderController = Get.put(CreateOrderController());
  Future<void> refesh() async {
    await cartController.awaitCurrentAccount();
  }

  @override
  Widget build(BuildContext context) {
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
          final listItem = cartController.listCartItem;
          final checkedItemFromList = cartController.checkedItems;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: checkedItemFromList.length == listItem.length
                            ? checkedItemFromList.isNotEmpty
                            : cartController.isCheckAll,
                        onChanged: (value) {
                          setState(() {
                            cartController.isCheckAll = value ?? false;
                            cartController.checkAll();
                          });
                        },
                      ),
                      const Text('Chọn tất cả'),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: size.width / 2.8,
                    height: size.height / 24,
                    margin: const EdgeInsets.only(right: 10),
                    child: DefaultButton(
                      enabled:
                          cartController.checkedItems.length == listItem.length,
                      press: () {
                        // cartController.clearCart();
                      },
                      text: 'Xoá giỏ hàng',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refesh,
                  child: ListView.builder(
                    itemCount: listItem.length,
                    itemBuilder: (context, index) {
                      final item = listItem[index];
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
                          String result = await cartController.removeItem(item);
                          if (result == "Success") {
                            CustomSuccessMessage.showMessage(
                                "Đã xoá sản phẩm thành công");
                          } else {
                            CustomErrorMessage.showMessage("Có lỗi xảy ra!");
                          }
                        },
                        child: SizedBox(
                          height: size.height / 9.5,
                          child: FutureBuilder<ProductDetailModel?>(
                            future: cartController
                                .getProductByDetail(item.productDetailId!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final detail = snapshot.data;
                                return FutureBuilder<ProductModel?>(
                                  future: cartController
                                      .getProductById("${detail?.productId}"),
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
                                                child: Checkbox(
                                                  value: cartController
                                                              .queryChekedItemList(
                                                                  item) !=
                                                          -1
                                                      ? true
                                                      : cartController
                                                          .isCheckAll,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      cartController
                                                          .isCheckAll = false;
                                                      cartController
                                                          .checkPerItem(item);
                                                    });
                                                  },
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  child: SizedBox(
                                                    height: size.height / 10,
                                                    width: size.width / 5.5,
                                                    child: CachedNetworkImage(
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
                                        title: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${item.quantity}x ${product?.productName} - ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: "${detail?.color}",
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: Column(
                                          children: [
                                            EditCartItemButton(
                                              isEnabled: true,
                                              // cartController.queryChekedItemList(item) ==
                                              //     -1,
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  builder:
                                                      (BuildContext context) {
                                                    return EditCartItemBottomSheet(
                                                        cart: item);
                                                  },
                                                );
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
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
          onPaymentPressed: () async {
            if (cartController.checkedItems.isEmpty) {
              CustomErrorMessage.showMessage(
                  'Bạn phải chọn ít nhất 1 sản phẩm để đặt hàng');
              return;
            }
          },
        ),
      ),
    );
  }
}
