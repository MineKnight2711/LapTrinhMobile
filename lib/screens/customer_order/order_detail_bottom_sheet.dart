import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';
import 'package:keyboard_mobile_app/model/query_order_model.dart';
import 'package:keyboard_mobile_app/screens/customer_order/components/list_order_detail.dart';
import 'package:keyboard_mobile_app/screens/customer_order/components/order_info.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import 'components/bottom_sheet_header.dart';

class OrderDetailBottomSheet extends StatelessWidget {
  final QueryOrder order;
  OrderDetailBottomSheet({super.key, required this.order});
  final orderController = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.90,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const BottomSheetHeader(),
        Expanded(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.transparent,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Image.asset('assets/images/bottom_sheet_banner.png'),
                  const Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  Visibility(
                      visible: order.status == "Đã giao",
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        height: size.height / 18,
                        child: DefaultButton(
                            press: () async {
                              return await showDialog(
                                context: context,
                                builder: (context1) {
                                  return AlertDialog(
                                    title: const Text('Xác nhận'),
                                    content:
                                        const Text('Bạn đã nhận đơn chưa ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context1).pop(false);
                                        },
                                        child: const Text(
                                          'Thôi',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          String result = await orderController
                                              .updateStatus(
                                                  order.orderId, "Đã nhận");
                                          if (result == "Success") {
                                            CustomSuccessMessage.showMessage(
                                                    "Nhận hàng thành công!")
                                                .then((value) =>
                                                    Navigator.pop(context))
                                                .whenComplete(() {
                                              replaceFadeInTransition(
                                                  context, HomeScreen());
                                            });
                                          } else {
                                            CustomErrorMessage.showMessage(
                                                result);
                                          }
                                        },
                                        child: const Text(
                                          'Đã nhận',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            text: "Đã nhận hàng"),
                      )),
                  Visibility(
                    visible: order.status == "Chờ xác nhận",
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      height: size.height / 18,
                      child: DefaultButton(
                          press: () async {
                            return await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Xác nhận'),
                                    content: const Text(
                                        'Bạn có chắc muốn huỷ đơn này?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text(
                                          'Thôi',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          String result = await orderController
                                              .updateStatus(
                                                  order.orderId, "Đã huỷ");
                                          if (result == "Success") {
                                            CustomSuccessMessage.showMessage(
                                                    "Đã huỷ thành công")
                                                .then((value) =>
                                                    Navigator.pop(context))
                                                .whenComplete(() {
                                              replaceFadeInTransition(
                                                  context, HomeScreen());
                                            });
                                          } else {
                                            CustomErrorMessage.showMessage(
                                                result);
                                          }
                                        },
                                        child: const Text(
                                          'Huỷ',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          text: "Huỷ đơn"),
                    ),
                  ),
                  const Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  //Thông tin đơn hàng
                  OrderInfoView(order: order),
                  const Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Danh sách sản phẩm',
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  //Chi tiết đơn hàng
                  Column(
                    children: order.listOrderDetail
                        .map((detail) => OrderDetailView(detail: detail))
                        .toList(),
                  ),
                  const Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Thành tiền:',
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          DataConvert().formatCurrency(order.total),
                          style: GoogleFonts.nunito(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 12,
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
