import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/screens/order_screen/components/order_item.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text('Tên chủ acc'),
                          ),
                          Expanded(flex: 2, child: Text('Địa chỉ'))
                          // Expanded(child:
                          // //Text('${controller.user.}'))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: kDefaultIconLightColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: const Text(
                                'Thay đổi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
              // ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     itemCount: cartController.checkedItems.length,
              //     itemBuilder: (context, index) => Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 10),
              //           child: Column(
              //             children: [
              //               Obx(
              //                 () =>
              //               ),
              //               const Divider()
              //             ],
              //           ),
              //         )),
            ),
          ),
        ],
      ),
    );
  }
}
