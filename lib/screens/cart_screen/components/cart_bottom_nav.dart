import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/mediaquery.dart';
import '../../../controller/cart_controller.dart';
import '../../../utils/data_convert.dart';
import '../../../widgets/custom_widgets/custom_button.dart';

class CartBottomNavigation extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPaymentPressed;

  CartBottomNavigation(
      {super.key, required this.totalPrice, required this.onPaymentPressed});
  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 4.0,
      child: Container(
        height: mediaHeight(context, 12),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            color: Color.fromARGB(255, 210, 217, 221)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            totalPrice == 0
                ? const Text(
                    '......',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Tổng cộng: ${DataConvert().formatCurrency(totalPrice)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
                height: mediaHeight(context, 18),
                width: mediaWidth(context, 3),
                child:
                    DefaultButton(text: 'Thanh toán', press: onPaymentPressed))
          ],
        ),
      ),
    );
  }
}
