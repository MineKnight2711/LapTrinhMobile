import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/screens/order_screen/components/order_item.dart';

import 'default_address.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final cartController = Get.find<CartController>();
  final addressController = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 130.99,
            width: 335,
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 100.0,
                    width: 335,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    child: Obx(
                      () {
                        if (addressController.currentDefaultAddress.value !=
                            null) {
                          return AddressView(
                            address:
                                addressController.currentDefaultAddress.value!,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20 * (MediaQuery.of(context).size.width) / 375),
              child: Obx(
                () => Column(
                  children: cartController.checkedItems.map((element) {
                    return Column(
                      children: [
                        PayCartItem(
                          cartProduct: element,
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
