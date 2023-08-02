import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';

import '../../utils/data_convert.dart';
import '../../widgets/custom_widgets/custom_appbar.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/message.dart';
import 'components/cart_bottom_nav.dart';
import 'components/edit_cart_bottom_sheet.dart';
import 'components/edit_cart_button.dart';

class CartScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();

  CartScreen({super.key});
  // final orderController = Get.put(CreateOrderController());
  // final userController = Get.find<AccountApi>();
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
          // var checkedItemFromList = cartController.checkedItems;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: cartController.checkedItems.length ==
                            listItem.length,
                        onChanged: (value) {
                          if (value!) {
                            cartController.checkedItems.assignAll(listItem);
                          } else {
                            cartController.checkedItems.clear();
                          }
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
                    itemBuilder: (BuildContext context, int index) {
                      final item = listItem[index];
                      return Obx(() {
                        bool isChecked =
                            cartController.checkedItems.contains(item);
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
                              CustomErrorMessage.showMessage("Có lỗi xảy ra!");
                            }
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: size.height / 10,
                              width: size.width / 4,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 1,
                                    right: 85,
                                    child: Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        if (isChecked) {
                                          cartController.checkedItems
                                              .remove(item);
                                        } else {
                                          cartController.checkedItems.add(item);
                                        }
                                        print(
                                            cartController.checkedItems.length);
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: SizedBox(
                                        height: size.height / 10,
                                        width: size.width / 5.5,
                                        child: Image.asset(
                                          "assets/images/banner1.png",
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
                                    text: "${item.quantity}x Tên sản phẩm - ",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "Màu sản phẩm",
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text("Danh mục"),
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
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      builder: (BuildContext context) {
                                        return EditCartItemBottomSheet(
                                            cart: item);
                                      },
                                    );
                                  },
                                ),
                                Text(
                                    ' ${DataConvert().formatCurrency(696969)}'),
                              ],
                            ),
                          ),
                        );
                      });
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
          totalPrice: cartController.totalPrice.value == 0 ||
                  cartController.totalPrice.value.isNaN
              ? 0
              : cartController.totalPrice.value,
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
