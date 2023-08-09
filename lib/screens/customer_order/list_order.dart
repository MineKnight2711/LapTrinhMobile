import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';
import 'package:keyboard_mobile_app/screens/customer_order/components/order_item.dart';
import 'package:keyboard_mobile_app/screens/customer_order/components/sorting_popups_menu.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:lottie/lottie.dart';
//enum theo sau là một tập hợp các giá trị hằng số được đặt trong dấu ngoặc nhọn {}

class ListOrderScreen extends StatelessWidget {
  ListOrderScreen({super.key});
  final orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Đơn hàng của tôi",
        actions: [SortingPopupMenu(orderController: orderController)],
      ),
      body: RefreshIndicator(
        onRefresh: orderController.refresh,
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaHeight(context, 0.9),
            child: Obx(() {
              if (orderController.listQueryOrder.isNotEmpty) {
                return Column(
                  children: orderController.listQueryOrder
                      .map(
                        (queryOrder) => QueryOrderCard(
                            queryOrder: queryOrder,
                            orderController: orderController),
                      )
                      .toList(),
                );
              }
              return SizedBox(
                height: mediaHeight(context, 1),
                width: mediaWidth(context, 1),
                child: Column(
                  children: [
                    Lottie.asset("assets/animations/loading_cart_item_3.json",
                        width: 100, height: 100),
                    Center(
                      child: Text(
                        "Đang tải đơn hàng, vui lòng chờ...",
                        style: GoogleFonts.nunito(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
