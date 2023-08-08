import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/screens/order_screen/components/body.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';

import '../../controller/cart_controller.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/cart-pay';
  OrderScreen({super.key});
  final cartController = Get.find<CartController>();
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
            final currentAccount = await cartController.awaitCurrentAccount();
            if (currentAccount != null) {}
          },
        ),
      ),
    );
  }
}
