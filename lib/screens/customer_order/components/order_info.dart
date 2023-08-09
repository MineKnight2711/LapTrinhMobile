import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/model/query_order_model.dart';

import '../../../utils/data_convert.dart';

class OrderInfoView extends StatelessWidget {
  final QueryOrder order;
  const OrderInfoView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Thông tin đơn hàng',
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            ],
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      'Tên người nhận',
                      style: GoogleFonts.nunito(fontSize: 13),
                    ),
                    Text(
                      DataConvert().splitAddress(order.receiverInfo)[0],
                      style: GoogleFonts.nunito(fontSize: 13),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  width: 0.8,
                  color: Colors.black,
                ),
              ),
              Positioned(
                right: 80,
                child: Column(
                  children: [
                    Text(
                      'Số điện thoại',
                      style: GoogleFonts.nunito(fontSize: 13),
                    ),
                    Text(
                      DataConvert().splitAddress(order.receiverInfo)[1],
                      style: GoogleFonts.nunito(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black38,
            thickness: 2,
          ),
          Row(
            children: [
              Text(
                'Mã đơn hàng: ',
                style: GoogleFonts.nunito(fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                order.orderId,
                style: GoogleFonts.nunito(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
