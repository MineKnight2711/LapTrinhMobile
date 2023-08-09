import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';
import 'package:keyboard_mobile_app/model/query_order_model.dart';
import 'package:keyboard_mobile_app/screens/customer_order/components/list_order_detail.dart';
import 'package:keyboard_mobile_app/screens/customer_order/components/order_info.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';

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
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: BottomSheetHeader()),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/bottom_sheet_banner.png'),
                  const Divider(
                    color: Colors.black38,
                    thickness: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    height: size.height / 18,
                    child: DefaultButton(press: () {}, text: "Đã nhận hàng"),
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
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
