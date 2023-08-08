import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';
import 'package:keyboard_mobile_app/model/order_model.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/screens/order_screen/components/body.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/utils/show_animations.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../controller/address_controller.dart';
import '../../controller/cart_controller.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/cart-pay';
  OrderScreen({super.key});

  final cartController = Get.find<CartController>();
  final addressController = Get.find<AddressController>();
  final orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          cartController.getCartByAccountId();
          cartController.onClose();
          Navigator.pop(context);
        },
        title: 'Đặt hàng',
        backGroundColor: Colors.transparent,
      ),
      body: Body(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.shopping_basket),
          label: const Text("Đặt hàng"),
          onPressed: () async {
            showOrderLoadingAnimation(
                context, "assets/animations/loading_1.json", 180);
            final currentAccount = await cartController.awaitCurrentAccount();
            if (currentAccount != null) {
              OrderModel newOrder = OrderModel();
              if (addressController.chosenAddress.value != null) {
                newOrder.receiverInfo =
                    "${addressController.chosenAddress.value?.receiverName}-${addressController.chosenAddress.value?.receiverPhone}-${addressController.chosenAddress.value?.address}";
              } else {
                newOrder.receiverInfo =
                    "${addressController.currentDefaultAddress.value?.receiverName}-${addressController.currentDefaultAddress.value?.receiverPhone}-${addressController.currentDefaultAddress.value?.address}";
              }
              newOrder.accountId = currentAccount.accountId;
              newOrder.orderDate = DateTime.now();
              String result = await orderController.saveOrder(
                  newOrder, cartController.checkedItems);
              if (result == "Success") {
                CustomSuccessMessage.showMessage("Đặt hàng thành công")
                    .then((value) {
                  Navigator.pop(context);
                  replaceFadeInTransition(context, HomeScreen());
                }).whenComplete(() {
                  cartController.calculateCartTotal();
                  cartController.deleteManyItem();
                });
              } else {
                CustomSuccessMessage.showMessage(result)
                    .then((value) => Navigator.pop(context));
              }
            } else {
              CustomSuccessMessage.showMessage("Phiên đăng hập không hợp lệ!");
            }
          },
        ),
      ),
    );
  }
}
