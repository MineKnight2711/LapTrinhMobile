import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';

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
        height: mediaHeight(context, 6.7),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: mainBottomNavColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              'Tổng cộng: ${DataConvert().formatCurrency(totalPrice)}',
              style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: mainAppThemeColor),
            ),
            // Divider(
            //   height: mediaHeight(context, 30),
            //   thickness: 2,
            // ),
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the indent based on the available width for the Divider
                double indent = (constraints.maxWidth -
                        DataConvert().formatCurrency(totalPrice).length * 12) /
                    2;
                return Divider(
                  height: mediaHeight(context, 30),
                  thickness: 2,
                  indent: indent / 2,
                  endIndent: indent / 2,
                  color: mainAppThemeColor,
                );
              },
            ),
            SizedBox(
              height: mediaHeight(context, 18),
              width: mediaWidth(context, 1.5),
              child: Obx(
                () => DefaultButton(
                  enabled: cartController.totalPrice.value > 0 &&
                      cartController.checkedItems.isNotEmpty,
                  text: 'Thanh toán',
                  press: onPaymentPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
